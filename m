Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYKRWcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYKRWcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYKRWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:31:56 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42815 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYKRWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:31:55 -0500
Date: Tue, 18 Nov 2008 16:31:00 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, pjssilva@ime.usp.br,
       akpm@linux-foundation.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com
Subject: Re: [PATCH] eCryptfs: Allocate up to two scatterlists for crypto
	ops on keys
Message-ID: <20081118223100.GC6581@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081114164053.GC6624@halcrowt61p.austin.ibm.com> <c384c5ea0811140849x9f6df35kaa36ff7ce2192ddf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0811140849x9f6df35kaa36ff7ce2192ddf@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 05:49:58PM +0100, Leon Woestenberg wrote:
> Hello,
> 
> On Fri, Nov 14, 2008 at 5:40 PM, Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> >
> > -       sg_init_table(&dst_sg, 1);
> > -       sg_init_table(&src_sg, 1);
> 
> Why did you remove the inits?

This initialization is done in virt_to_scatterlist() and is thus
redundant for this function.

> With self-checking enabled in the kernel, sg accessor functions will
> check on proper initialization and BUGON().
> 
> It might be your use-case would not hit this, as it seems not to use
> sg_ macro's much.
> 
> Regards,
