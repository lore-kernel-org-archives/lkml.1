Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZDBTXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZDBTXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZDBTWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:22:39 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:43346 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932806AbZDBTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eyBT10hSAXDm+sfCi/ODAasusgeY08fXPJtSJhtA5NAmmaV0PrJyDe3g59BtZYYTOvaJYcQae6t1Evc5PzcrQt28OI2Va+dJE5vbIp1hzDEJEF9Rt/YdzYzfY2uMQolI4HjWXDELBmDkSHt3k0buKDJRazhpIb+94rTfYDtU0Vk=  ;
X-YMail-OSG: y2o0qdsVM1kcd.H5KtJzgGA1fi25zduauOSIpj8vT4VKO5Zm3luApkD18okv9r9iUBnZO1l1vXEteMGhdWhb67Y71Tth3dB_uslCni.Yz5H7WmIzB6NrWvTWSFo6t_OiRDxDou74QW.IUi7J2nD8BB.W8QnwgW0FFSKTcVp_8EqnygHr5ScOOQMK9olU_YAL58ut0xp2MCkuXtUXzxeUN.d9.MqKAM045m3EqB9muToZJQfcUoTt6lJsW0En846FeUmzQfeST2AAww_4BmvgExGlcQEt1BS.J_MAdwIaJKJMfXDUDXRt
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/6] Guest page hinting version 7.
Date: Fri, 3 Apr 2009 06:22:29 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, frankeh@watson.ibm.com, hugh@veritas.com
References: <20090327150905.819861420@de.ibm.com> <20090402175249.3c4a6d59@skybase> <49D50CB7.2050705@redhat.com>
In-Reply-To: <49D50CB7.2050705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030622.30935.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 06:06:31 Rik van Riel wrote:
> Martin Schwidefsky wrote:
> > The benefits are the same but the algorithmic complexity is reduced.
> > The patch to the memory management has complexity in itself but from a
> > 1000 feet standpoint guest page hinting is simpler, no? 
> Page hinting has a complex, but well understood, mechanism
> and simple policy.
> 
> Ballooning has a simpler mechanism, but relies on an
> as-of-yet undiscovered policy.
> 
> Having experienced a zillion VM corner cases over the
> last decade and a bit, I think I prefer a complex mechanism
> over complex (or worse, unknown!) policy any day.

I disagree with it being so clear cut. Volatile pagecache policy is completely
out of the control of the Linux VM. Wheras ballooning does have to make some
tradeoff between guests, but the actual reclaim will be driven by the guests.
Neither way is perfect, but it's not like the hypervisor reclaim is foolproof
against making a bad tradeoff between guests.
