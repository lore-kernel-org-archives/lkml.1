Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXJCIki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXJCIki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbXJCIkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:40:32 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:45742 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752562AbXJCIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:40:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IjnbKu7/bawW5Y7nYVpOx3B6nLsfmoIZw5mVrOHFA+dfkrycHd5/TgjDIeuRwoX5CoaCq5RNp0HVBRLaAGPOIN1mR+UKhHgGKtQOXodKgUTKZINZ30ap+eOZwj3oDu4vcch65EBE1AD6J6GPaPGgtfXrhfGFU092/WgIIEHQ8Dc=  ;
X-YMail-OSG: sf8Rtb8VM1nxvfm2bKNAXyKOoyYafq7NLaok774voN.jAUJ5IGbEs.DR1CmbIuOvqQvdV4v7Ag--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] mark read_crX() asm code as volatile
Date: Wed, 3 Oct 2007 01:49:24 +1000
User-Agent: KMail/1.9.5
Cc: Chuck Ebbert <cebbert@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Kirill Korotaev <dev@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
References: <470250E0.5090706@openvz.org> <200710022214.55381.nickpiggin@yahoo.com.au> <4703342E.3020101@zytor.com>
In-Reply-To: <4703342E.3020101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030149.24914.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 16:18, H. Peter Anvin wrote:
> Nick Piggin wrote:
> >> This should work because the result gets used before reading again:
> >>
> >> read_cr3(a);
> >> write_cr3(a | 1);
> >> read_cr3(a);
> >>
> >> But this might be reordered so that b gets read before the write:
> >>
> >> read_cr3(a);
> >> write_cr3(a | 1);
> >> read_cr3(b);
> >>
> >> ?
> >
> > I don't see how, as write_cr3 clobbers memory.
>
> Because read_cr3() doesn't depend on memory, and b could be stored in a
> register.

How does the compiler know it doesn't depend on memory?

How do you say it depends on memory? You really need something
as heavy as volatile?
