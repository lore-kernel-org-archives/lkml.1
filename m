Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZKBQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZKBQmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZKBQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:42:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:62744 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZKBQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:42:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=juEzdcu1IPcHUBZubHA0EbNbO2lpkSLZXj1Iq/r+hdYP1c+unKJZ+dEiISXcpMevc6
         lhvxmhLoJh+sdpSp+IKG1RQP6p15Eyuap3uTZVVhNZp0IaTCyyRkeJ2/aSMyr6tuxSNF
         oglQF/PwGaoS2zwoAJfGY1fdO/bfklLq9ktwU=
Message-ID: <4AEF0E98.5050304@gmail.com>
Date: Mon, 02 Nov 2009 17:53:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mchan@broadcom.com
Subject: [PATCH] cnic: ensure ulp_type is not negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`ulp_type' is signed, make sure it is not negative
when we read the array element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/cnic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 3bf1b04..f384b0a 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -347,7 +347,7 @@ int cnic_register_driver(int ulp_type, struct cnic_ulp_ops *ulp_ops)
 {
 	struct cnic_dev *dev;
 
-	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
+	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
 		printk(KERN_ERR PFX "cnic_register_driver: Bad type %d\n",
 		       ulp_type);
 		return -EINVAL;
@@ -393,7 +393,7 @@ int cnic_unregister_driver(int ulp_type)
 	struct cnic_ulp_ops *ulp_ops;
 	int i = 0;
 
-	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
+	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
 		printk(KERN_ERR PFX "cnic_unregister_driver: Bad type %d\n",
 		       ulp_type);
 		return -EINVAL;
@@ -449,7 +449,7 @@ static int cnic_register_device(struct cnic_dev *dev, int ulp_type,
 	struct cnic_local *cp = dev->cnic_priv;
 	struct cnic_ulp_ops *ulp_ops;
 
-	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
+	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
 		printk(KERN_ERR PFX "cnic_register_device: Bad type %d\n",
 		       ulp_type);
 		return -EINVAL;
@@ -490,7 +490,7 @@ static int cnic_unregister_device(struct cnic_dev *dev, int ulp_type)
 	struct cnic_local *cp = dev->cnic_priv;
 	int i = 0;
 
-	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
+	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
 		printk(KERN_ERR PFX "cnic_unregister_device: Bad type %d\n",
 		       ulp_type);
 		return -EINVAL;
