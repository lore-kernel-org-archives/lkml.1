Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXK0TKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXK0TKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbXK0TK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:10:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44897 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXK0TK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:10:27 -0500
Date: Tue, 27 Nov 2007 11:09:19 -0800
From: Greg KH <greg@kroah.com>
To: darnok@68k.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071127190919.GA10686@kroah.com>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <200711262323.35416.konrad@darnok.org> <20071127052955.GB777@kroah.com> <20071127180950.GA6736@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127180950.GA6736@andromeda.dapyr.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 02:09:50PM -0400, darnok@68k.org wrote:
> On Mon, Nov 26, 2007 at 09:29:55PM -0800, Greg KH wrote:
> > On Mon, Nov 26, 2007 at 11:23:31PM -0500, Konrad Rzeszutek wrote:
> > > On Monday 26 November 2007 22:31:38 Greg KH wrote:
> > > > > +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
> > > ..snip..
> > > > > +static ssize_t find_ibft(void)
> > > > > +{
> > > ..snip..
> > > > > +}
> > > >
> > > > What is a function (not even an inline one) doing in a .h file?
> > > 
> > > I was not sure where to put it. This function (find_ibft) is used by the 
> > > setup_[32|64].c and the iscsi_ibft.c code. Randy suggested I put in .c file, 
> > > but I am not sure exactly where? Should I make a new file in called 
> > > libs/iscsi_ibft_helper.c ?
> > 
> > Put it in your .c file and make it a global function to be called by
> > someone else if they need it.
> 
> If the kernel is built with CONFIG_ISCSI_IBFT=m, the
> setup_[32|64],c code would depend on the 'find_ibft' symbol which is
> in a module (in the iscsi_ibft.c), which is not available during
> the bootup phase and not linked to vmlinuz.

Ah, then don't allow that :)

> This isn't an issue if the module is built with CONFIG_ISCSI_IBFT=y of
> course.
> 
> Or did by 'your .c file' mean a new file in arch/x86/kernel directory?

I didn't realize an external file, outside of your changes, needed this
function.  If it does, then perhaps you need to just place it elsewhere.

thanks,

greg k-h
