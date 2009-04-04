Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZDDGJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZDDGJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 02:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZDDGJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 02:09:38 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:20786 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751025AbZDDGJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 02:09:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wDQjgIaph+p0QCE8WhBOgE302UPVf1HHdH/+hbw+KHF++PXhVyh2tcSOhmBKzD+/WO+3TGyn9rXRllm7wiQ/72/4BjCwkvvzS0qeELG/7gmOY0rakgGlsa2GSUSkJSUUtdlQCW8Pv2kaorO4rzgefZfZNFpBGBkcIJ6VwhPyxWg=  ;
X-YMail-OSG: EeQQQgIVM1m5RNfdElvqamOzYONP.BRe5_dZsSPw6PJNlZuLqr1kdMawIs0JW0Bu9g1_pzZACjVCiwYSAiXbQdcuEaR2VRrVH_Ov1MvCL5eU6M5spx4P4yf46HoL_CUOeV741l1LDdzs0aAH_TjzKjpaDyBkyDokjic79tFhw8nckIp.M4h0fahbL8ip.MDnj8rFwPCx6dGn350CbNvzaGu3H5C6ylZvJoqDxZTLHMGDDf_ob5p13bFYb_UGSdf58lmQFMnj_NSjIp_8yEFcw6AspwqwYf7uDUxRw3xIgMhLKvHk90rP
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/41] CacheFiles: Permit the page lock state to be monitored [ver #48]
Date: Sat, 4 Apr 2009 17:09:31 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk> <20090403155624.28714.87176.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155624.28714.87176.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904041709.31651.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 April 2009 02:56:24 David Howells wrote:
> Add a function to install a monitor on the page lock waitqueue for a particular
> page, thus allowing the page being unlocked to be detected.
> 
> This is used by CacheFiles to detect read completion on a page in the backing
> filesystem so that it can then copy the data to the waiting netfs page.

This is the only thing I'm still worried about in core code. The extra
page flag (which is probably unusable for any other fs, due to its
semantics) is an issue, but Andrew seemed like he was willing to spend
*2* page flags on this, so I'm sure he's happy with 1.

But this I still don't like.

I didn't get any reply when asking about the asynchronous nature of
this. It certainly adds huge complexity to the code, at points which
can tend to be quite synchronous anyway.

I would really like to know exactly why it *has* to be asynchronous,
and see what the diff looks like between a simple synchronous design
and what you have here.
