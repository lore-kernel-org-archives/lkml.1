Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYJEQpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYJEQpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbYJEQlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:41:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:40222 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbYJEQlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ZpZmIpGrnK5rjT1qU+oo8J/zL+tsxlyTj/YyOB+/N1bnwpEbCOXpiUO5vII4gTYLBs
         zb7GlJrk5X0GH49v2b8yBCUk1bcVyrBQC3/zvSdp/+ahyHNktDebwnOOoSoAhvWXjhx2
         H8FU8PlnvHlVoUD477KoMuBMgKbLfRpqRcyGA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Date: Sun, 5 Oct 2008 18:14:58 +0200
User-Agent: KMail/1.9.10
Cc: "Elias Oltmanns" <eo@nebensachen.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net> <f488382f0809101544o5aa9d9d1scdf64a1d0b004d07@mail.gmail.com> <200809271740.38980.bzolnier@gmail.com>
In-Reply-To: <200809271740.38980.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810051814.58293.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 September 2008, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 11 September 2008, Steven Noonan wrote:
> > On Wed, Sep 10, 2008 at 3:40 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
> > >
> > > What about changing the declaration to
> > >
> > >        int i, uninitialized_var(rc);
> > >
> > > then?
> > >
> > 
> > That's probably a -much- better idea. I'm an utter newbie to kernel
> > development, so I wasn't aware of that feature.
> 
> Did I miss the final patch version?
> 
> [ Could you please re-send and/or re-cast it? ]

Oh, well...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: workaround for bogus gcc warning in ide_sysfs_register_port()

Reported-by: "Steven Noonan" <steven@uplinklabs.net>
Suggested-by: "Elias Oltmanns" <eo@nebensachen.de>
Cc: mingo@elte.hu
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1492,7 +1492,7 @@ static struct device_attribute *ide_port
 
 static int ide_sysfs_register_port(ide_hwif_t *hwif)
 {
-	int i, rc;
+	int i, uninitialized_var(rc);
 
 	for (i = 0; ide_port_attrs[i]; i++) {
 		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
