Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbXLPVLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbXLPVLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbXLPVLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:11:42 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:26266 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756987AbXLPVLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:11:41 -0500
Date: Mon, 17 Dec 2007 00:10:00 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Jean-Marc Saffroy <jean-marc.saffroy@orange-ftgroup.com>
Cc: daniel.pirkl@email.cz, linux-kernel@vger.kernel.org
Subject: Re: fsx failure on ufs2
Message-ID: <20071216211000.GA10964@rain>
Mail-Followup-To: Jean-Marc Saffroy <jean-marc.saffroy@orange-ftgroup.com>,
	daniel.pirkl@email.cz, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.61.0712141649230.10387@brutus.ri.silicomp.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712141649230.10387@brutus.ri.silicomp.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 05:21:31PM +0100, Jean-Marc Saffroy wrote:
> For an embedded system, I'm currently evaluating the robustness of ufs2 
> write support on Linux, and my very first test, with fsx, shows serious 
> problems.
>
> My test bed is a single CPU PC with a single IDE disk, that boots FreeBSD 
> 6.2 and Ubuntu 7.10. The kernel on Ubuntu is a vanilla 2.6.23.9 with UFS2 
> write support. fsx is from the freebsd cvs (with a small patch to build on 
> Linux, see after my sig):
>   http://www.freebsd.org/cgi/cvsweb.cgi/src/tools/regression/fsx/
>

I used fsx-linux.c from ext3-tools project, but ran it with
different options.

>
> Can anyone else confirm this problem?
>
Using your options I am able to reproduce this bug.
Looks like problem in ufs_alloc_lastblock, last page in file
contains zeros, but because of ufs_readpage, it can be contains 
garbage. I will look at next week how it can be fixed.

-- 
/Evgeniy

