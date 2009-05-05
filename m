Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZEEQWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZEEQWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZEEQV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:21:58 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44292 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbZEEQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:21:57 -0400
Subject: kobject_set_name() uses GFP_KERNEL
From: Marcel Holtmann <marcel@holtmann.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 05 May 2009 09:21:42 -0700
Message-Id: <1241540502.2987.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

all the users of kobject_set_name() which includes dev_set_name() are
allocating their memory for the device name with GFP_KERNEL. It is not a
big deal since device_add() does the same. However it is not obvious and
I ran into an issue in the Bluetooth stack where I was setting the
device name from a context that can't sleep. If this behavior is on
purpose, we better add an extra comment in the documentation.

Regards

Marcel


