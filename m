Return-Path: <linux-kernel-owner+w=401wt.eu-S1161595AbXEDSfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161595AbXEDSfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161599AbXEDSfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:35:47 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:7031 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161595AbXEDSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XrfiPS94V5ffZjizn3Ea+ZrVxTCobLlJo3DjsxJxejcFwgc1NpIwYtHs3CuypbSecVGe+SuMnedYSpX7Ytr+zISq293Ffk6iyt0B22Aq8VzeVICcbj6gzL/0eM4LlunLniN2MwWhxBgJFR2QXXV9bwXZYiiK6C08F8p8cvvv7CQ=
Message-ID: <524f69650705041135i7633cd34xd0b03bc2abd25c2@mail.gmail.com>
Date: Fri, 4 May 2007 13:35:44 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeremy Allison" <jra@samba.org>
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a distinct module
Cc: "Gerald Carter" <coffeedude.jerry@gmail.com>, simo <idra@samba.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070504171200.GE31976@samba1>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
	 <1178198489.28758.14.camel@localhost.localdomain>
	 <20070503141742.GB20328@infradead.org>
	 <1178203013.28758.29.camel@localhost.localdomain>
	 <4639F5AD.20807@gmail.com> <20070504171200.GE31976@samba1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Jeremy Allison <jra@samba.org> wrote:
> On Thu, May 03, 2007 at 09:46:05AM -0500, Gerald Carter wrote:
> > Long term I agree that CIFS and SMB2 should be in the same .ko
>
> Actually I disagree. I think Christoph is correct. These
> are two independent protocols and should be in two different
> modules.
>
> > But NTLM 0.12 still works for Vista and DFS referrals.
> > Breaking out SMB2 initially means that it will not clutter
> > the working cifs.ko code.  Remember that an SMB2 client fs is
> > mostly research at this point, and not engineering.
>
> Long term the common functions should be factored out
> and put into a lower-level module that both cifs and
> SMB2 are dependent upon.
>
> That's the cleaner solution IMHO.
>
> Jeremy.

There is also the obvious tradeoff of  "easier to update frequently"
vs. "easier to write" which is a primary factor.

1) as distinct .ko files smb2 and cifs can be updated independently
(the former marked broken/experimental).  Updating smb2 won't
risk breaking cifs

2)  but implemented in the same module, there is somewhat less code to write.




-- 
Thanks,

Steve
