Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbXI1OMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbXI1OMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbXI1OMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:12:00 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:32021 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758870AbXI1OL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:11:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Xkw5fYMGw8DWBSgNHLfqwtAAf85mqqH6VLze8KmNcxqjWoj25/K4VBeEzZoGbS3vtpTuTPgNSKtZARwhgNrdg2GYbcjsI+0t1nu1oczESzcEmKT/SiQN3SvCqrUErhaf/bHMlUOl8aaah4keUlfRyv+IEDUJ0DgkVck5P9r80vU=  ;
X-YMail-OSG: nX_iBtUVM1lMp90hzYacZprlGEuCsqmp7W4v0K_wYmhazo67XA.VBN9mKE4JCx2WTfowUg1p.g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS Fails Quality Assurance Tests on ARM
Date: Fri, 28 Sep 2007 07:40:48 +1000
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, byron.bbradley@gmail.com,
       linux-kernel@vger.kernel.org
References: <fb80ve$i5q$1@sea.gmane.org> <20070830.213901.48806818.davem@davemloft.net> <p73ps12vxrl.fsf@bingen.suse.de>
In-Reply-To: <p73ps12vxrl.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709280740.48723.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 08:14, Andi Kleen wrote:
> David Miller <davem@davemloft.net> writes:
> > From: Byron Bradley <byron.bbradley@gmail.com>
> > Date: Fri, 31 Aug 2007 03:12:46 +0000 (UTC)
> >
> > > Anybody got any ideas of how we fix this?
> >
> > I don't know how much testing XFS gets on ARM, but one thing that some
> > ARM chips have is D-cache aliasing problems and one thing XFS uses a
> > lot is virtual remapping of various data structures via vmap().
> >
> > This might be what is causing the problems.
>
> AFAIK XFS uses vmap() mainly during log replay. If David's theory
> was true then the failures must be seen during tests that do
> this.

I think it can also do vmap for directory lookups, and it crashed
in some directory lookup AFAIKS.

One way to verify would be to create the XFS filesystem with PAGE_SIZE
directory blocks (mkfs.xfs -nsize=PAGE_SIZE) I believe. Dave will correct
me if I'm wrong.

