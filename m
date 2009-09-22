Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZIVSz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZIVSz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZIVSzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:55:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64223 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZIVSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sJAxUT3hTbV2VCec058sfZ6Td5m74Yu5BK4CLTJiPPigDCR/njarv+6USoG398WS7N
         F/AzqtnbKlBeT0HVcTsI5GexIutaDYPHEobvlcykBk2n2zN4Ec/VYKPnqsX4/xPLPiJD
         r4KeGYE1FOQrTp5adpezmUHElpw8gmy26MnPE=
MIME-Version: 1.0
In-Reply-To: <1253624054-10882-2-git-send-email-mel@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
	 <1253624054-10882-2-git-send-email-mel@csn.ul.ie>
Date: Tue, 22 Sep 2009 21:55:55 +0300
X-Google-Sender-Auth: abf9e3724731bb4d
Message-ID: <84144f020909221155s27facd66rc852f5e6b28eb593@mail.gmail.com>
Subject: Re: [PATCH 1/4] slqb: Do not use DEFINE_PER_CPU for per-node data
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 3:54 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> SLQB uses DEFINE_PER_CPU to define per-node areas. An implicit
> assumption is made that all valid node IDs will have matching valid CPU
> ids. In memoryless configurations, it is possible to have a node ID with
> no CPU having the same ID. When this happens, per-cpu areas are not
> initialised and the per-node data is effectively random.
>
> An attempt was made to force the allocation of per-cpu areas corresponding
> to active node IDs. However, for reasons unknown this led to silent
> lockups. Instead, this patch fixes the SLQB problem by forcing the per-node
> data to be statically declared.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Applied, thanks!
