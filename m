Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZLIOrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZLIOrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZLIOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:47:22 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42125 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZLIOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:47:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=O+xww7rIcMOnYasT21ElPxU1CFoG2Ce65BSY7HHP8zDh2Wq82wQAiEUe4YU84v3N9c
         YZGuyxp7fx7zO49WKFhmGHPWA0HtX1ithv+V37FujwPqDMlUGkT/wFx5nqfkif4qW0dw
         KIQKrhKa5/5+mIucC1OU7EoQcp/aXefEaJUi0=
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 22:47:28 +0800
Message-ID: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
Subject: Questions about Watch Dog Timer under Linux.
From: Cypher Wu <cypher.w@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm used to work on embedded systems, the Watch Dog Timer in our
products is usually a seperate chip on the board wich will start to
work after power reset and will time out in 2 seconds. The system has
to start dog clearing from the very beginning and there have no way to
disable WDT.
Now I want to use WDT under Linux, while I read
Documentation/watchdog/watchdog-api.txt and then look though some
drivers of WDT under Linux, it seems WDT under Linux has to be able to
be disabled, and it will be disabled from the beginning, and starting
to work after the application open the special driver file?  The
sample code under Linux use a very bigger time span than our embedded
system:
	while (1) {
		ret = write(fd, "\0", 1);
		if (ret != 1) {
			ret = -1;
			break;
		}
		ret = fsync(fd);
		if (ret)
			break;
		sleep(10);
	}


Is this the pattern we have to follow to use WDT under Linux? We have
to choose a chip as WDT, and it seems the chip we've familiar under
embedded systems can't be used under Linux?
