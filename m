Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYHYUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYHYUyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYHYUyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:54:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:46127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYHYUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kl2cNtIKxTY6bJJbDG4FZ60V94WNlJD4p+wGMODwCeQP4pGnXd4Oulo+reYJm93wme
         nQor5LzBQ0/EGl94keurAqJIu1BuZ9Sm4b+01fmJdQD8Kdd2DCr3wyxKA1+1GgzLGQD9
         uVhOCrHqu+4BFTS4WAZhMx7aLjwbQKVhFqPjU=
Date: Mon, 25 Aug 2008 22:53:36 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jochen Voss <jochen.voss@googlemail.com>
Cc: jassi_singh_brar@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
Message-ID: <20080825205221.GA5635@joi>
References: <801995.65435.qm@web33201.mail.mud.yahoo.com> <ef1cd66f0808250522s5b661e21k772ce208afa33489@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef1cd66f0808250522s5b661e21k772ce208afa33489@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 01:22:16PM +0100, =?ISO-8859-1?Q?Jochen_Vo=DF_ wrote:
> >
> > static LIST_HEAD(vbd_head);
> >
> > static struct device vir_dev = {
> >        .bus_id = "virblk",
> > };
> >
> > static int data_xfer(struct vir_blk_dev *vbd, struct page *page, unsigned int len,
> >                                unsigned int off, int wr, sector_t sector)
> 
> strange indentation
> 
> > {
> >        ssize_t ret;
> >        loff_t pos = sector * (1<<(vbd->sect_size_bits));
> >        void *buf = kmap(page) + off;
> >
> >        if(sector + (len >> vbd->sect_size_bits) > get_capacity(vbd->gd)){
> 
> Kernel coding style seems to prefer spaces after "if" and before "{"
> (more instances below).

It's better to check this patch with scripts/checkpatch.pl - it will tell you
about all style issues.

> >        init_MUTEX(&vbd->sem);

You seem to use this semaphore as a mutex - why don't you convert it to mutex then?
Semaphores should be used only when they are absolutely necessary.

Marcin
