Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461Ab0AGSky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0AGSky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442Ab0AGSkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:40:52 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56845 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0AGSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:51 -0500
Date: Thu, 7 Jan 2010 19:30:09 +0100
From: Bastian Blank <waldi@debian.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 7/7] Input: wacom - Fail on missing features
Message-ID: <20100107183009.GA13036@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100107182553.GA11236@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver needs a correct setup feature list, fail if it is not
correctly set.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/input/tablet/wacom_sys.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 41a631b..c44b9f0 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -534,6 +534,9 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	struct input_dev *input_dev;
 	int error = -ENOMEM;
 
+	if (!features)
+		return -EIO;
+
 	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
 	wacom_wac = kzalloc(sizeof(struct wacom_wac), GFP_KERNEL);
 	input_dev = input_allocate_device();
-- 
1.6.5.7


-- 
Well, Jim, I'm not much of an actor either.
