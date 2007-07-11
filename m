Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbXGKEMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbXGKEMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXGKEMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:12:00 -0400
Received: from 241-226.umostel.ru ([77.246.241.226]:62452 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbXGKEL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:11:59 -0400
Message-ID: <46945895.6070004@aknet.ru>
Date: Wed, 11 Jul 2007 08:12:05 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: William Tambe <tambewilliam@gmail.com>
CC: Hugh Dickins <hugh@veritas.com>,
       "Rohland, Hans-Christoph" <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com> <46893F97.7080200@aknet.ru> <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com> <4692E5DF.7080304@gmail.com> <Pine.LNX.4.64.0707102056140.4107@blonde.wat.veritas.com> <4693F242.2030004@gmail.com>
In-Reply-To: <4693F242.2030004@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

William Tambe wrote:
> I understand your concern. But since I am working on a dynamic memory 
> management code that I wish to use with other projects that I have, I 
> didn't find appropriate to use shm_open.
Could you please provide a detailed list of the
problems you have with shm_open? If they are
valid, then I can bet the patch will be applied,
no matter what. :)

> In fact there is a name associated with the shared memory requested with 
> shm_open, so that it can be mmap(ed) in another process. And I do not 
> wish to have it accessible by any other process, unless I choose to do so.
In this case you need to use shm_unlink() right
after shm_open(). Then this shm will be accessable
only to your process and its children, via an fd,
and not to anyone else. And you still can do anything
with it (ftruncate/mmap/mremap whatever).

> And I think remap(ing) ANONYMOUS memory kind of make a lot of things easier.
In what way, exactly?

