Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbYANPia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbYANPia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYANPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:38:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:28074 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYANPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ca/37kvPadstYw5Gj6arYc22+ZFNhlk7JQB6Ui6Bhh1A9OkEO4j0a2KQKraVzSZ3y5l8RQc7oPfqu6aBexNkjZvJYfy+qzK+T5IMytBJf4DC59sYh+5Qp/LBcML8h3bC2eU3sOmCsYvgNXj9U+xdHkbxrnCvSL0kqfJ0E82pvVQ=
Date: Mon, 14 Jan 2008 18:38:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Message-ID: <20080114153806.GA6639@cvg>
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com> <478A82AD.3070904@gmail.com> <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com> <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com> <478B7C4A.5090903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B7C4A.5090903@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Mon, Jan 14, 2008 at 04:14:18PM +0100]
> On 01/14/2008 07:38 AM, Cyrill Gorcunov wrote:
>> This patch converts ioctl call to unlocked_ioctl form. It's possible
>> due to rtl_lock spinlock protection.
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>> The patch is *not* tested but the patch does not bring _much_ changes
>> so it wouldn't break the compilation procedure.
>> If there is problem with attachment - i could send it as inline
>> form today evening.
>
> Yes, please, especially if it is app/octet-stream (base64 encoded 
> plaintext). Also Cc akpm or somebody who will pick your patch up.
>

ok

>> Andi, Jiri, Alexey the only thing I do complain about -
>> is time set/read from several user threads that uses same
>> (duplicated) file descriptor. Could there be useless thread
>> spins instead of sleep (in case if this unlocked_ioctl were
>> protected by mutex)?
>
> Sorry, what?
>

Jiri, I mean rtc_open() is protected by spinlock+status from being
opened simultaneously by a few processes. *But* lets imagine the
following situation - this fd (file descriptor) is opened by one
multithreaded application so all threads have an access to this
fd. Then one thread reads rtc periodically thru unlocked_ioctl
and another thread set new time from time to time. So the question
I have - is it possible to get second thread stopped at attemption to
get rtc spinlock while another thread is setting the new time? Or
this situation never-ever could be? i'm not really familiar with
process management in Linux and as result could be wrong.

		- Cyrill -
