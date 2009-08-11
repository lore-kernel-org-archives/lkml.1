Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZHKVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZHKVB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZHKVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:01:57 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:57380 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZHKVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:01:57 -0400
Date: Tue, 11 Aug 2009 23:01:46 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090811210146.GB9910@braap.org>
References: <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org> <4A81683D.2030408@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A81683D.2030408@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> I disagree. The bridge drivers should register their resources with the  
> core. The core, or a layer above it, can control how those resources are  
> used. This moves the complexity you want for managing the windows to a  
> level that will work on all underlying drivers rather than having to be  
> written explicitly for each one. The mechanism I have provided does this  
> discovery.

nah, it would be foolish to think we can write an upper layer
that covers every corner case for every bridge we're gonna
encounter. For instance, imagine a bridge that has 10 windows,
with the annoying feature that window#10 *only* accepts CS/CSR
mappings. How stupid is that? Very stupid. But what would be
more stupid is to write allegedly 'generic' interfaces that
break every time a bridge comes up with a stupid feature.

So that doesn't belong to a generic interface. Now, to avoid
code duplication between two (or more) _very_ similar bridges,
we just share the 'resource management' code among those,
privately. And that's pretty much it.

Regards,
E.
