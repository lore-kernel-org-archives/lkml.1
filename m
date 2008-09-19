Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbYISAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbYISAsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYISAsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:48:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:5703 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbYISAsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LD715cWnWVHFhjuHsX6Qisr9h//Lk7dnN6iUWmCzfWie/xr44Un94VESIvQDgUKTyT
         Sa1llnC4/BXt3sKiHLOmXLPTd0CrhtaHQt+XIdTaOA/U1goJ0YaI/eqwvK0dSN1N/O1w
         ksQjfI9faZrbax4vBzQdWzqQi0z89zQDR2d28=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 3/4 v2] ide: Implement disk shock protection support
Date: Thu, 18 Sep 2008 17:47:31 -0700
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <87d4j2n3dn.fsf@denkblock.local> <200809181624.54248.bzolnier@gmail.com> <87d4j17ze2.fsf@denkblock.local>
In-Reply-To: <87d4j17ze2.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181747.31715.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2008 17:28:05 Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Wednesday 17 September 2008 09:38:37 Elias Oltmanns wrote:
> >> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> >
> >> FEATURE as specified in ATA-7 is issued to the device and processing of
> >> the request queue is stopped thereafter until the specified timeout
> >> expires or user space asks to resume normal operation. This is supposed
> >> to prevent the heads of a hard drive from accidentally crashing onto the
> >> platter when a heavy shock is anticipated (like a falling laptop expected
> >> to hit the floor). Port resets are deferred whenever a device on that
> >> port is in the parked state.
> >> 
> >> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> >
> > applied
> 
> I'm very sorry for responding so late to Tejun's concerns but I got
> bitten by the uaccess bug in recent linux-next discussed on LKML.
> 
> @Bart, one isue raised by Tejun actually applies to this ide patch as
> well. Even though the problem is considerably more complex in the libata
> case than I had bargained for, we are lucky in the ide case. Still, we
> need to move prepar_to_wait() to the top of the while loop. Can you
> please include the following interdiff? It also gets rid of a
> superfluous variable.

done, thanks!
