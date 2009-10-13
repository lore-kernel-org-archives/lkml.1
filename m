Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZJMFKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZJMFKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZJMFKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:10:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZJMFKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZfuNiXIFH1WshLJWFGyCt4k5+gj+2jTGGfe1Nyn3fu4AYPuoCaS3z7hTUPTVGHy5Lx
         SdwUdtFPXZhynWNpOphw+T3ao/r0O7/tpjFoYqRGRoYmwxb88gYNT1g/zn4HDBAhd4j9
         8RVuzG6cE2TkXPxo4DpGSulmKmnHlgGXi9Htw=
MIME-Version: 1.0
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20091012153013.GA2062@suse.de>
	 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20091012172953.GA10557@suse.de>
	 <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
Date: Tue, 13 Oct 2009 08:08:49 +0300
X-Google-Sender-Auth: 05a55111edbe4e98
Message-ID: <84144f020910122208k1fde7e60hce873e81a6436f57@mail.gmail.com>
Subject: Re: [patch] Staging: hv: Fix vmbus load hang caused by wrong data 
	packing
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hank,

On Mon, Oct 12, 2009 at 11:10 PM, Hank Janssen <hjanssen@microsoft.com> wrote:
>>Ideally, we don't deal with packed structures at all, but with offsets
>>in memory and pick out the proper fields and put them into new
>>structures if you want to use them that way.  How hard would that be to
>>do here instead?
>
> It is something that I want to look at in the future. Our primary focus
> Is to get the bug fixed. We cannot do the offset way in the time we
> Have before 2.6.32 closes and still be comfortable we have gone through
> The extensive testing cycle we do on our side.

We don't merge fixes to the kernel unless we understand _why_ they fix
things. It's pretty likely that the problem here is that one or more
of the structs you are putting under "#pragma pack" just need to be
annotated with "attribute packed".

                        Pekka
