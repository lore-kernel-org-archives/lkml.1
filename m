Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYBFSVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYBFSVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYBFSVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:21:12 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:52488 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYBFSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:21:11 -0500
Message-ID: <47A9FA93.4070202@tiscali.nl>
Date: Wed, 06 Feb 2008 19:21:07 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: ballabio_dario@emc.com, linux-scsi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][drivers/scsi/u14-34f.c] duplicate test	'SCpnt->sc_data_direction
 == DMA_FROM_DEVICE'
References: <47A7937C.7040701@tiscali.nl> <1202319939.3112.89.camel@localhost.localdomain>
In-Reply-To: <1202319939.3112.89.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-02-04 at 23:36 +0100, Roel Kluin wrote:

>> Note the duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'

>> -   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
>> +   if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
>>        cpp->xdir = DTD_IN;
>>        return;
>>        }
>>     else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {

> 
> Well spotted, this is definitely a huge bug in the driver.
> 
> However, I think on closer examination that DTD_IN actually means
> transfer from device to host, so DMA_FROM_DEVICE is correct for that
> case.  It should be DMA_TO_DEVICE in the else if() piece.
> 
> Could you correct and resend the patch and I'll apply it.

Thanks for your review.
---
Direction of data transfer 'DMA_FROM_DEVICE' was tested twice. DTD_OUT
means  transfer from host to device. This should occur when the
direction of data transfer (sc_data_direction) is 'DMA_TO_DEVICE'.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 662c004..58d7eee 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1215,9 +1215,9 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
    if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
       cpp->xdir = DTD_IN;
       return;
       }
-   else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
+   else if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
       cpp->xdir = DTD_OUT;
       return;
       }
    else if (SCpnt->sc_data_direction == DMA_NONE) {

