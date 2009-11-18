Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZKRUCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZKRUCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbZKRUCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:02:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbZKRUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:02:23 -0500
Date: Wed, 18 Nov 2009 21:02:27 +0100
From: Jan Blunck <jblunck@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118200227.GT21750@bolzano.suse.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk> <20091118175307.GQ21750@bolzano.suse.de> <20091118181712.14a2404c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118181712.14a2404c@lxorguk.ukuu.org.uk>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, Alan Cox wrote:

> > As I said, f_pos is changed without holding BKL in the VFS already. Therefore
> 
> IFF the VFS paths that change it can be invoked in parallel.
> 
> > even if the driver tries to protect f_pos by holding the BKL it is racing
> > against concurrent read()/write() anyway on f_pos.
> 
> It may simply be a matter of internal consistency. Anyway I've now made a
> list of the offenders so we can simply fix/delete them and continue.

Right. Thanks for that btw. I'll work on fixing them and followup with patches
tomorrow.

Thanks,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
