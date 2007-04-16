Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXDPTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXDPTDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXDPTDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:03:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:59839 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbXDPTDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sauGW6Djn1ir/Q6HUPYIrhBbUJrgXHRvXC6/+MnhokdalvUCPpYdp0oAewF9r74qi4+x5IRZ4+IRTck6KGaB0YBOpRjq5a71Ttqx7uX6BcC3JbKh5BK6qWbz8TLoyZ+kDdKm9d7Ih/3tGH9ByqiZ2kQvM4d4FBSmvqWO3UFEU/4=
Message-ID: <d120d5000704161203j7c476bb8m1c96d09adb819b6f@mail.gmail.com>
Date: Mon, 16 Apr 2007 15:03:16 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Tejun Heo" <htejun@gmail.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070416184716.GA6262@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	 <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
	 <20070416184716.GA6262@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Apr 16, 2007 at 02:30:17PM -0400, Dmitry Torokhov wrote:
> > On 4/16/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > >Hi,
> > >
> > >based on the discussion in "How should an exit routine wait for
> > >release() callbacks?", I've cooked up some patches that make module
> > >unload wait until the last reference for a kobject has been dropped.
> > >This should plug the "release function in already deleted module" race;
> > >however, if the last kobject_put() from the module containing the
> > >release function is not in the module's exit function, there's still a
> > >small window (not sure if and how to plug this).
> >
> > Unfortunately all this "wait for refcount in module's exit" schemas
> > lead to the following deadlock:
> >
> >        rmmod my_module < /path/to/some/file/incrementing/my/refcount
>
> No, it should just return "module in use" as the reference count it
> grabbed before rmmod is called.
>

No, because it it were module's refcount we woudl not have problem
with ->release() to begin with. It is object's refcount.

> But either way, that's just foolish to try to prevent that from failing
> :)

Why? It works now for most of teh subsystems.

-- 
Dmitry
