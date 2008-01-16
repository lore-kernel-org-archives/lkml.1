Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYAPRpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYAPRpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYAPRp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:45:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42664 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYAPRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:45:25 -0500
Date: Wed, 16 Jan 2008 19:45:22 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why is the kfree() argument const?
In-Reply-To: <Pine.LNX.4.64.0801160831490.8188@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0801161940400.6514@sbz-30.cs.Helsinki.FI>
References: <87lk6pvii0.fsf@saeurebad.de> <Pine.LNX.4.64.0801160831490.8188@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 Jan 2008, Johannes Weiner wrote:
> > is there any reason why kfree() takes a const pointer just to degrade it
> > with the call to slab_free()/__cache_free() again?  The promise that the
> > pointee is not modified is just bogus in this case, anyway, isn't it?
 
On Wed, 16 Jan 2008, Christoph Lameter wrote:
> The object is modified in various cases f.e. because of poisoning or the 
> need to store the free pointer. So its bogus, yes. Pekka?

Yeah, bogus, and has been that way for a long time according to git. I'm 
ok with removing that (which would make it consistent with the user-space 
equivalent free(3) function btw).

			Pekka
