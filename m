Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbZG0GU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbZG0GU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZG0GU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:20:27 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:56574 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZG0GU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uqjp76l7aJOhGcpmG36JGuY9lQ/m4wJvXmt0E6+/nQDG6zDFRwEAjmpzdzi2GXWA3o
         vUQUlA7qx7ABgpXaejAP/BZGJFGba9byQQtau57VfzhymGo92sGh6fRJodLmMJcXwmaj
         +S1ZoeFu7BCCrd5JiVFSwzR77ktSLSCsZz7Ss=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 27 Jul 2009 02:20:06 -0400
Message-ID: <8bd0f97a0907262320y3c5c3505h5d47d5c51025a536@mail.gmail.com>
Subject: early platform drivers vs resource lookup by name
To: Greg KH <gregkh@suse.de>, damm@igel.co.jp
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ive been toying with the new early platform driver framework and
noticed a not-so-friendly feature wrt resource handling.  the
platform_device_add() function will take care of making sure that
every resource's name field is not NULL:
int platform_device_add(struct platform_device *pdev)
{
...
        if (r->name == NULL)
            r->name = dev_name(&pdev->dev);
...

unfortunately, the early_platform_add_devices() function does not have
similar code.  this leads to NULL pointer crashes if you attempt to
use any of the "byname" resource functions (e.g.
platform_get_resource_byname) and the resources in question arent
fully named.

is the simple fix here to add a resource loop to
early_platform_add_devices() that makes sure all the name fields are
non-NULL ?
-mike
