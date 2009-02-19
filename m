Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZBSMgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZBSMgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBSMgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:36:41 -0500
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:31376 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752973AbZBSMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:36:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0N8JrvDKU7JDKF5Lmrengo0IlgctrdCXV6F6nytYT+U+0LNCRw9tQEcXlilU/Y9j1KhSklATE4fn3z+wk7xnrRUo1ggNNSdTscBn4nUEMi+m0PBaV+sW347ekJpA99iBSN6LAbCZ+siebGOGcU7UpDfEincbsjKSN1W8PSPYDW8=  ;
X-YMail-OSG: C0VewPoVM1mujyUN8SGUCyJUrRKrHiSG1UihjkShbEaRqW2AUuZb701DgLA8AG9ljyYUqlKun.ML9c1x7Vp_WNqy7w9zHJqFEsVfwE8F9o6UG6U2M0Owyl.yCvJW3Hg23FS9USV0Cut9WKtN_AOce2YeYiqVZea8nDYzY5poAMLSwCe8yw0SvdcK.4Jy5g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Date: Thu, 19 Feb 2009 23:36:01 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192336.02800.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 23:04:35 Tejun Heo wrote:
> Impact: new scalable dynamic percpu allocator which allows dynamic
>         percpu areas to be accessed the same way as static ones
>
> Implement scalable dynamic percpu allocator which can be used for both
> static and dynamic percpu areas.  This will allow static and dynamic
> areas to share faster direct access methods.  This feature is optional
> and enabled only when CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is defined by
> arch.  Please read comment on top of mm/percpu.c for details.

Seems pretty nice. Wishlist: would be cool to have per-cpu virtual
memory mappings and do CPU-local percpu access via a single pointer.
Of course there would need to be some machinery and maybe a new API
to be more careful about accessing remote percpu data (that access
could perhaps just be slower and go via the linear mapping).

It would probably be quite a bit slower to do remote percpu access,
but some users never do this remote access in fastpath, and want
really fast local access (eg slab allocators).

I guess the hardest part would be doing the arch code.

