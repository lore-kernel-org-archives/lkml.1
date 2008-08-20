Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYHTR4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYHTR4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYHTR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:56:05 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:24684 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752086AbYHTR4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:56:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nWRaNO9shNKukrhtppdVO/Jtj5+5CfRodRnudgjNiZergKqAt2lyrvv/NJu/JRe1q4JkkviyfPww9UVKjDeVdf5rC5iwyxbVC7+lCddfbOl1YiSz9FB8acBPsPCButleizBeKNpuudCuGw8My1xY05j1ykIvx9SmexpVAEtjbkk=  ;
X-YMail-OSG: AHQ9rZwVM1niHR1ukMKQBqhzJ150YLRl4Vou0RrPDv9mdWBfQ1BpIoa8bhK_C1s3OLONz1eiY3N._2R1V6oMFFj40tCLRXhKu_YOpECgXnYdjlwC_qEw_yFHcshy_FU2x1U-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Date: Thu, 21 Aug 2008 03:55:54 +1000
User-Agent: KMail/1.9.5
Cc: Ray Lee <ray-lk@madrabbit.org>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
References: <1912217169.25608.228.camel@ymzhang> <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com> <1219252901.8651.63.camel@twins>
In-Reply-To: <1219252901.8651.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210355.55597.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 03:21, Peter Zijlstra wrote:
> Ok, so one last time (I hope!)..
>
> Everybody happy with this?


> Index: linux-2.6/include/linux/kernel.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -367,6 +367,12 @@ static inline char *pack_hex_byte(char *
>  	(void) (&_max1 == &_max2);		\
>  	_max1 > _max2 ? _max1 : _max2; })
>
> +#define avg(x, y) ({				\
> +	typeof(x) _avg1 = (x);			\
> +	typeof(y) _avg2 = (y);			\
> +	(void) (&_avg1 == &_avg2);		\
> +	_avg1 + (_avg2 - _avg1)/2; })

That's not going to work with unsigned types.
