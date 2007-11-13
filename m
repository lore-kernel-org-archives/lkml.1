Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXKNLwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXKNLwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXKNLwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:52:13 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:36977 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755138AbXKNLwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:52:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H8261jlf1WXnnCeePI68jqinNVHVEAd9JBEjxm6v/gwhh8ljfHFtm83fOnL/mgFKNjix7TDyJozU/eobtKbB143S3UKZfV4Oqt7IXCFy8Kuuv6xkBMlAf/D7R+dmenhzH9zk/GObRRB2k8KXVDDMC8bNgPmsQiDq0QY/Lfb94Ks=  ;
X-YMail-OSG: pQKL.XUVM1k4CDTjBCCGhnh5srpxaoQtllRZHx25DpCOLo2MJjTB8DAzq_vEmaG0ZUaXUfsUQQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Wed, 14 Nov 2007 10:49:48 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, hch@infradead.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       eranian@hpl.hp.com, wcohen@redhat.com, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
References: <20071114103805.GA16652@infradead.org> <20071114.031216.11725447.davem@davemloft.net> <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
In-Reply-To: <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141049.49154.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 22:44, Paul Mackerras wrote:
> David Miller writes:
> > This is my impression too, all of the things being done with
> > a slew of system calls would be better served by real special
> > files and appropriate fops.
>
> Special files and fops really only work well if you can coerce the
> interface into one where data flows predominantly one way.  I don't
> think they work so well for something that is more like an RPC across
> the user/kernel barrier.  For that a system call is better.
>
> For instance, if you have something that kind-of looks like
>
> 	read_pmds(int n, int *pmd_numbers, u64 *pmd_values);
>
> where the caller supplies an array of PMD numbers and the function
> returns their values (and you want that reading to be done atomically
> in some sense), how would you do that using special files and fops?

Could you implement it with readv()?
