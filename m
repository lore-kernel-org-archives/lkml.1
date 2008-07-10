Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYGJOWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYGJOWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYGJOWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:22:00 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35584 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754378AbYGJOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:21:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KB/fKo6/U+bSNnrMBRlgq11ZuUV3jsaGxOQXKFht4lggs+Ai2m3FVfQPlWsJaZUAy3mlLsfIgHqn4Zvj/93Tjyhtt/YmaMIojq4JmlBb/0keqfLI8e1RH/JshkZK6no7H03u/O28FSJHeANAgIt+3BWxRmJ37ss0+daGxcxlSS4=  ;
X-YMail-OSG: BciAAKUVM1m__7sPUjXiwJfBpei7fwN8fdI8MibZfhNcsEFXkMBxu40TZnZ1rZRxG8JyWU8bcI11_gOUCN9eD.XZCvCrSS_rvWhsmUDkcBuFYBBprG_gOQvb.l58iF0wqrk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Date: Fri, 11 Jul 2008 00:21:28 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       cl@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
References: <20080703213348.489120321@attica.americas.sgi.com> <200807101731.54910.nickpiggin@yahoo.com.au> <20080710132903.GA17830@sgi.com>
In-Reply-To: <20080710132903.GA17830@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807110021.29392.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 23:29, Jack Steiner wrote:
> On Thu, Jul 10, 2008 at 05:31:54PM +1000, Nick Piggin wrote:
> > On Thursday 10 July 2008 05:11, Jack Steiner wrote:

> > > I'll post the new GRU patch in a few minutes.
> >
> > It looks broken to me. How does it determine whether it has a
> > normal page or not?
>
> Right. Hugepages are not currently supported by the GRU. There is code that
> I know is missing/broken in this path. I'm trying to get the core driver
> accepted, then I'll get the portion dealing with hugepages working.

Oh, I meant "normal" pages as in vm_normal_page(), or is there some
other reason this codepath is exempt from them?

Using gup.c code I don't think will prevent your driver from getting
accepted. Conversely, I would not like the open coded page table walk
to go upstream...
