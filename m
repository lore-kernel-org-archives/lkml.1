Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZBFRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZBFRP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbZBFRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:15:04 -0500
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:57098 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756885AbZBFRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:15:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=IlQL5rV0cL6IwksHeNn5fTiYdpk4HpayyxqzDuCAN3oJ+8sgvdtZjdpRxcw8CmToVCsNr4RBrNAbgkmYTDHR345Z8I8Jla+Z5yGKWvn442rrwe4kGhg6uGbqjQ841eeK;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Subject: Re: Gem GTT mmaps..
Date: Fri, 6 Feb 2009 09:14:59 -0800
User-Agent: KMail/1.9.10
Cc: Thomas =?iso-8859-15?q?Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <498A1760.7010108@shipmail.org> <1233790920.16368.4.camel@gaiman> <200902051037.20590.jbarnes@virtuousgeek.org>
In-Reply-To: <200902051037.20590.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902060914.59956.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 5, 2009 10:37 am Jesse Barnes wrote:
> So if we leave the lookup reference around from the GTT mapping ioctl, that
> would take care of new mappings.  And if we added/removed references at VM
> open/close time, we should be covered for fork.  But is it ok to add a new
> unref in the finish ioctl for GTT mapped objects?  I don't think so,
> because we don't know for sure if the caller was the one that created the
> new fake offset (which would be one way of detecting whether it was GTT
> mapped). Seems like we need a new unmap ioctl?  Or we could put the mapping
> ref/unref in libdrm, where it would be tracked on a per-process basis...

Ah but maybe we should just tear down the fake offset at unmap time; then we'd 
be able to use it as an existence test for the mapping and get the 
refcounting right.  The last thing I thought of was whether we'd be ok in a 
map_gtt -> crash case.  I *think* the vm_close code will deal with that, if 
we do a deref there?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
