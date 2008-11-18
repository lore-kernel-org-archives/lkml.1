Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYKRQUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYKRQUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYKRQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:20:34 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:24878 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751960AbYKRQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:20:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SnKf8sb1XiCQvjQSd+JO/n504I4BMpSQ+l9pj9T/uZowfyWMxw9Drf4aOf969uphOWjd4rDSvchpWbQHrYIiZbq9WEaOWTYt5W2PzH6fslrUacaAJ6mXjYdzVgfxlsPnmTwhPHbhUUiNB6KPHvfM0qLhnTdS5F6jTH2B8/2dbio=  ;
X-YMail-OSG: uesqZQQVM1ku5X.CziOEqszUvoaxoBL9w09scK7tzGKDzSvQKIni6ojGni7U9fPc9eDM9_WoVUN.CEbFat_NVYPvNUbvucJ0nc9H9_K8nTiim0vMrO4WJ4unJMvNJO9bi1zzoUaTepBsci9_RHHwHtBgVf82svGISoWuKXYO
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Kumar Gala <kumar.gala@freescale.com>
Subject: Re: questions on how x86 uses IPI for tlb invalidates
Date: Wed, 19 Nov 2008 03:20:25 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel Kernel <linux-kernel@vger.kernel.org>
References: <6F2B69F5-7312-49AB-B86A-6AE6B753095B@freescale.com> <200811190303.00474.nickpiggin@yahoo.com.au> <07E85AE1-3F9B-45A0-BBFF-22B8DAD54158@freescale.com>
In-Reply-To: <07E85AE1-3F9B-45A0-BBFF-22B8DAD54158@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811190320.25720.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008 03:06, Kumar Gala wrote:
> On Nov 18, 2008, at 10:03 AM, Nick Piggin wrote:

> > You can't do the broadcast TLB invalidates in kunmap_atomic.
> > All that's needed in that case is to just invalidate the local
> > CPU.
>
> Agreed, I was planning on fixing that.  I guess the high level
> question is if a broadcast invalidate can occur in soft or hard irq
> context.

x86 does them for unmapping KVA (except kunmap_atomic), and
unmapping UVA. Unmapping KVA (eg. kunmap, vunmap) is not allowed
in irq context.

So long as you fix kunmap_atomic, you shouldn't have a problems.
