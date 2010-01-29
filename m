Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257Ab0A2VsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0A2VsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185Ab0A2VsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:48:10 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:43117 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0A2VsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:48:08 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 16:48:07 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HLokORn5xEAFuxDmWK1ZTaVV0bkH5JpZQQXxKDR8llIBRQGdTEk5PIdpPt5O0igLSj
         8ouE0xABhNOAJsF4gaTtqU7QnKROI8OB3gtaDKspbI5JGzOEMn0TPVnjmML084ZquQ4U
         xArt2hG90YrD9wGXlmsD2YGbC7DkVt9r5BFY8=
Message-ID: <4B6355DF.9050001@garzik.org>
Date: Fri, 29 Jan 2010 16:40:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
References: <20100129160308.21495.14120.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 11:03 AM, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> Here is a patchset (on top of atang-v3.1 tree) applying "out-of-the-box"
> thinking to duplicated libata PATA and IDE subsystem host driver sets.
> Namely, it modifies IDE API slightly to match libata's one more, adds
> a tiny source-code level translation layer (ide2libata.h header file
> which consists of only 17 lines of code) and then converts host drivers
> to use shared source code for low-level operations (all drivers have
> been carefully audited during porting to minimize the probability of
> adding regressions accidentally).  As an end result it is much easier
> to maintain both driver sets (differences between 'new'/'old' drivers
> are now apparent and there is no longer a need to manually back-port
> many classes of bugfixes) and over 2500 LOC are gone.

Interesting.

I'm fine with applying patches 2-5, but I am definitely interested to 
hear what others think about this.  Clearly, LOC is reduced, but that's 
not the only factor in code maintenance.

With regards to libata and old-IDE, I have always thought the ideal 
scenario was to leave old-IDE in bugfix-only mode, with next-to-no API 
or driver churn besides that which is absolutely required for the fix.

En masse backporting bug fixes is what's known as a one-time cost.  Once 
the majority of libata PATA drivers reach bugfix and feature parity, the 
need for code sharing is reduced greatly.

The ide2libata proposal creates on-going costs, not just a one-time 
cost, because the old-IDE drivers will have -increased- potential for 
problems when a libata PATA driver is modified.  Such is the -cost- of 
heavily intertwined code sharing.  A single header change implies that 
two, not one, drivers might break.  That weakens the "leave it alone" 
stability promise of old-IDE.

Waiting for other comments...  this patchset is not an onerous burden to 
libata, but I think it creates nasty cross-tree issues, potentially 
perturbing old-IDE.

	Jeff


