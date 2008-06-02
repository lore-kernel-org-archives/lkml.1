Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYFBK5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYFBK5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYFBK5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:57:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:14086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYFBK5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hFl8KcIiBYAZCAqdGjzJwW/nqJWPGA9pCKFGDk3MDCXauWjN3XkGUrsp7nAZEUaVO0b6GwQn22/P7ImluKJNk9p2bhAaUKKTMUdjNFouSXfjkH0YlnJOIqPyT1VinU5Nbwo2CAcUfvZMrxO9wXd0QHnnPbZeXVrtoP2Y39vF3Mk=
Message-ID: <19f34abd0806020357w6478704dt50226f51c6c62701@mail.gmail.com>
Date: Mon, 2 Jun 2008 12:57:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       "Joe Peterson" <joe@skyrush.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080602105210.GH18697@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de>
	 <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core>
	 <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core>
	 <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
	 <19f34abd0806020339m100fd3f8m6c0c6ff0c08a66d2@mail.gmail.com>
	 <20080602105210.GH18697@devserv.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 12:52 PM, Alan Cox <alan@redhat.com> wrote:
> On Mon, Jun 02, 2008 at 12:39:29PM +0200, Vegard Nossum wrote:
>> Shouldn't it be EINTR to allow the signal to be processed and let the
>> process decide whether to retry the tcsetattr()?
>
> The signal is processed, and then application retries the tcsetattr and
> gets another one. The default TTOU behaviour is to block and then fg
> continues the call so RESTARTSYS is both correct and has been used for
> years
>

Hm, yes, that seems correct. I'm sorry for the wrong suggestions.

I guess this still doesn't explain why TTOU doesn't block (IOW, stop
the process, right?) in this case, because my test program does not
touch it.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
