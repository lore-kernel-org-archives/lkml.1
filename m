Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYBSQX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYBSQX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYBSQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:23:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46219 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYBSQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:23:20 -0500
Date: Tue, 19 Feb 2008 08:16:10 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #5.1)
Message-ID: <20080219161610.GA3344@kroah.com>
References: <20080212180859.GA12876@sergelap.austin.ibm.com> <47B2A3F3.8060701@ak.jp.nec.com> <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com> <20080218074056.GA19915@kroah.com> <47B945BA.2060107@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B945BA.2060107@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 05:45:46PM +0900, Kohei KaiGai wrote:
> Greg KH wrote:
> >>> Also, this code can be cleaned up a lot by just using the basic kobject
> >>> attributes, and not rolling your own types here.
> >> I replaced my own defined capability_attribute by kobj_attribute.
> >>
> >> It made the patch cleaned up, however, it also impossible to share a single
> >> _show() method instance, because kobj_attribute does not have any private member.
> >> Is there any reason why kobj_attribute does not have "void *private;"?
> > 
> > Because no one has asked for it?  :)
> > 
> > Or you can just do as the example in samples/kobject/ does it, no need
> > for the void pointer as that code shows.
> 
> It shows us a good example in samples/kobject.
> 
> However, it is unsuitable to export the list of capabilities.
> The shared _show() method (b_show) calls strcmp() once with the name of kobject
> attribute to switch its returning string.
> If we have 34 of candidates to be returned, like the capability case, we have
> to call strcmp() 33 times in maximum.
> 
> If we can have a private member in kobj_attribute, we can found the content
> to be returned in a single step.

Ok, again, just send me a patch that adds this functionality and we will
be very glad to consider it.

thnaks,

greg k-h
