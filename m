Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYHUIUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYHUIUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYHUITw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:19:52 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:37264 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbYHUITu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IZklBTPpjnz8ePbNF2WE/bXywPWgXmyRkX+yGt8DXWXoT0fbK+bVfHfmrT56S3+j1e
         CO09OS6aiEUldx34eldJW9Ibh5GgExpuoXAjth1x+cpSl+/R+5+UrT5QOVR8WYKOPuYt
         gHHmfILXk6XjObZ/EUiWw5S24boAf8j5rPon0=
Message-ID: <19f34abd0808210119m70d95ea0t93d9887944a0c84b@mail.gmail.com>
Date: Thu, 21 Aug 2008 10:19:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "jay kumar" <jaykumarks@gmail.com>
Subject: Re: Bug: "bad unlock balance detected" 2.6.27-rc3-next-20080820
Cc: "David Howells" <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6f31812b0808210004i63b3273ehf65ce9eb139256f0@mail.gmail.com>
	 <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 10:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Aug 21, 2008 at 9:04 AM, jay kumar <jaykumarks@gmail.com> wrote:
>> While testing 2.6.27-rc3-next-20080820 ,  i observed this    "BUG:bad
>> unlock balance detected" during boot time
>>
> Thanks for the report. The error comes from
>
> commit d9a939fb80ef390b78b3c801f668bd1e35ebc970
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Aug 7 20:02:20 2008 +1000
>
>    CRED: Make execve() take advantage of copy-on-write credentials
>
> (Added to Cc. I guess it's also nice to Cc linux-next on errors in -next code.)
>
> I couldn't reproduce your original failure, but I've attempted to fix
> it by reordering the mutex unlock and bprm free and removing the
> extraneous unlock (see attached patch; it boots for me without
> errors).

Actually, I was able to reproduce the original issue after all. And
the patch fixed it for me. Please review :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
