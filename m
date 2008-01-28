Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbYA1OKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbYA1OKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYA1OKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:10:39 -0500
Received: from ns.suse.de ([195.135.220.2]:54894 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYA1OKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:10:38 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 15:10:34 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20080127317.043953000@suse.de> <200801281427.36048.ak@suse.de> <20080128133857.6c53ac9f@core>
In-Reply-To: <20080128133857.6c53ac9f@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281510.35200.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 14:38:57 Alan Cox wrote:
> > Also worse really fixing it would be a major change to the VFS 
> > because of the way ->read/write are defined :/
> 
> I don't see a problem there. ->read and ->write update the passed pointer
> which is not the real f_pos anyway. Just the copies need fixing. 

They are effectually doing a decoupled read/modify/write cycle. e.g.:

A               B

read fpos       

                read fpos

fpos += A       fpos += B
                write fpos


write fpos

So you get overlapping reads. Probably not good.

-Andi
