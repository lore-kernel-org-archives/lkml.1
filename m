Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYC2Bdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYC2Bdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYC2Bde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:33:34 -0400
Received: from n9.bullet.re3.yahoo.com ([68.142.237.94]:21842 "HELO
	n9.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756215AbYC2Bdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:33:33 -0400
X-Yahoo-Newman-Id: 768142.62980.bm@omp202.mail.re3.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Xlkllsoe80cmtDV4Q/iZSNFR7JQDn3tHt4gvunPcgKc0jgRIWRmVhBRy/84rZGrLiteBjEMZnIaGUzgfMPsCkFvfU/yU2VcYYnEuSJ+Qho/rb4b2mtTzSt5J7CwQ4rph1S07ybT205awRgrsdHTtlyr0Gq8Ev6H12R3/s/6j9yg=  ;
X-YMail-OSG: Yd5I00oVM1lId6gl4fhFYRKtG6rKUBWF6HHqIW6gCEjkClsJR_9oduKecnxdUqeP7PCLJCah9A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: down_spin() implementation
Date: Sat, 29 Mar 2008 12:04:36 +1100
User-Agent: KMail/1.9.5
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <200803281101.25037.nickpiggin@yahoo.com.au> <20080328124517.GQ16721@parisc-linux.org>
In-Reply-To: <20080328124517.GQ16721@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803291204.36855.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008 23:45, Matthew Wilcox wrote:

> I think we can do better here with:
>
> 	atomic_set(max);
>
> and
>
> 	while (unlikely(!atomic_add_unless(&ss->cur, -1, 0)))
> 		while (atomic_read(&ss->cur) == 0)
> 			cpu_relax();

Yeah of course! That's much better ;)

I'd say Tony could just open code it for now, which would get him
up and running quickly... although if anybody gets keen to add it
as a generic API then I wouldn't object.

