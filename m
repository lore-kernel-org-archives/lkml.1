Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbXISQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbXISQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760986AbXISQRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:17:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:34609 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760961AbXISQRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:17:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] i386/PAE: avoid temporarily inconsistent pte-s
Date: Wed, 19 Sep 2007 18:17:30 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <46F150CB.76E4.0078.0@novell.com> <200709191809.47351.ak@suse.de> <46F16779.76E4.0078.0@novell.com>
In-Reply-To: <46F16779.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191817.30569.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 18:16:25 Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 19.09.07 18:09 >>>
> >On Wednesday 19 September 2007 16:39:39 Jan Beulich wrote:
> >> One more of these issues (which were considered fixed a few releases
> >> back): Other than on x86-64, i386 allows set_fixmap() to replace
> >> already present mappings. Consequently, on PAE, care must be taken to
> >> not update the high half of a pte while the low half is still holding
> >> the old value.
> >
> >Hmm perhaps it would be better to just forbid it on i386 too.
> >Do you know who uses it?
> 
> PCI's mmconfig accessor. One could of course make it call clear_fixmap() prior
> to establishing a new mapping, but I thought that was not intended and is the
> reason for allowing this.

Makes sense. Applied thanks.

-Andi

