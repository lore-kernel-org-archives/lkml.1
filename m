Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbXGLGjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbXGLGjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXGLGjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:39:10 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:12033 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbXGLGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ECf1L4I0kAbmeRIiLJULnHEsrMyHhI9Rpq8B5aQDVKbBtZiY1/RTNDUAKukEHDjpXxcoDdzm2BPAVNqiYItvjIC/bPQsuk4MPyK7HHEWLZ9XK1bS1ZAjUz2/F0lMM8QeaaujDSLjhkzY1aPNUFXLYtnBsi6nsLQX0S4IrYLPrzg=
Message-ID: <4695CBC8.20508@gmail.com>
Date: Thu, 12 Jul 2007 01:35:52 -0500
From: William Tambe <tambewilliam@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: Hugh Dickins <hugh@veritas.com>,
       "Rohland, Hans-Christoph" <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com> <46893F97.7080200@aknet.ru> <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com> <4692E5DF.7080304@gmail.com> <Pine.LNX.4.64.0707102056140.4107@blonde.wat.veritas.com> <4693F242.2030004@gmail.com> <46945895.6070004@aknet.ru>
In-Reply-To: <46945895.6070004@aknet.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Stas Sergeev wrote:
> Hi.
> 
> William Tambe wrote:
>> I understand your concern. But since I am working on a dynamic memory 
>> management code that I wish to use with other projects that I have, I 
>> didn't find appropriate to use shm_open.
> Could you please provide a detailed list of the
> problems you have with shm_open? If they are
> valid, then I can bet the patch will be applied,
> no matter what. :)
> 
>> In fact there is a name associated with the shared memory requested 
>> with shm_open, so that it can be mmap(ed) in another process. And I do 
>> not wish to have it accessible by any other process, unless I choose 
>> to do so.
> In this case you need to use shm_unlink() right
> after shm_open(). Then this shm will be accessable
> only to your process and its children, via an fd,
> and not to anyone else. And you still can do anything
> with it (ftruncate/mmap/mremap whatever).
> 

Ok, now I find myself without any other arguments :-) shm_unlink() right 
after shm_open() is a solution.


>> And I think remap(ing) ANONYMOUS memory kind of make a lot of things 
>> easier.
> In what way, exactly?
> 
> 

I wrote the above not knowing that I could use shm_unlink() right after 
shm_open(). But still, I have lost a considerable amount of time trying 
to figure that out.
It appeared all natural to me that I could just remap ANONYMOUS and get 
what I wanted. And the worst thing here is that the man pages do not let 
you know about that.

Sincerely,
William Tambe
