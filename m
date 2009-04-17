Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbZDQWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbZDQWxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZDQWxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:53:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43004 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZDQWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:53:11 -0400
Date: Fri, 17 Apr 2009 23:53:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: hooanon05@yahoo.co.jp, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Q: NFSD readdir in linux-2.6.28
Message-ID: <20090417225306.GO26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417224350.GN26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:43:50PM +0100, Al Viro wrote:
> On Fri, Apr 17, 2009 at 11:17:00PM +0100, David Woodhouse wrote:
> > It sounds like the better answer is to just make sure i_mutex is held
> > when nfsd_buffered_readdir() calls back into the provided filldir
> > function (we could do it in the various filldir functions themselves,
> > _if_ they call lookup_one_len(), but I think I prefer it this way --
> > it's simpler). Patch below for comment.
> 
> Umm...  I can live with that, assuming that we don't have callbacks
> that take i_mutex themselves.  AFAICS, everything we call there is
> either obviously not touching i_mutex or is already called while we
> hold i_mutex elsewhere, but I'd appreciate if somebody actually
> tested that sucker for different versions of protocol...

BTW, why mess with taking i_mutex inside the inner loop and not
immediately around it?
