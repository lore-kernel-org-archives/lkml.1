Return-Path: <linux-kernel-owner+w=401wt.eu-S1161729AbXDXMZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161729AbXDXMZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161730AbXDXMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:25:38 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:38863 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161729AbXDXMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:25:37 -0400
In-Reply-To: <ada3b2q7v9t.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>
MIME-Version: 1.0
Subject: Re: [PATCH] eHCA: Add "Modify Port" verb
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF9075E217.B145AD0F-ONC12572C7.0042D705-C12572C7.00443EC9@de.ibm.com>
Date: Tue, 24 Apr 2007 14:25:34 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 24/04/2007 14:25:35,
	Serialize complete at 24/04/2007 14:25:35
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 23.04.2007 21:20:14:

>  > +   if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != 
H_SUCCESS) {
>  > +      ehca_err(&shca->ib_device, "Can't query port properties");
>  > +      ret = -EINVAL;
>  > +      goto modify_port1;
>  > +   }
>  > +
>  > +   cap = (rblock->capability_mask | props->set_port_cap_mask)
>  > +      & ~props->clr_port_cap_mask;
>  > +
>  > +   hret = hipz_h_modify_port(shca->ipz_hca_handle, port,
>  > +              cap, props->init_type, port_modify_mask);
> 
> Is this thread-safe?  What if two different bits are set at the same
> time from two different threads?  It seems that both calls could get
> the same result from hipz_h_query_port(), and then the second call to
> hipz_h_modify_port() would overwrite the first call.

Yes, you're so right.
 
> You could look at the implementation in mthca to see the locking I
> used there.

I'll do that, thanks for the hint!

Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 
