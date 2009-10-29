Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZJ2VbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZJ2VbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZJ2VbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:31:00 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33958 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZJ2Va7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I0L8a4eA742ZyFaK39tLlPhNNa5nMSjIoqHWB65hq/G20QSp6cbspd+2lH2EMviFP9
         nAIq74L2qoraHg6deh8AFAc4e45QcaZ3EgKcJ8wHLlSyG9eEOJzfLY5t06nC6WCF80iR
         J47xKUVR26Cgc+ayHby+cHGSWnS9r7vRoBVgM=
MIME-Version: 1.0
In-Reply-To: <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
Date: Thu, 29 Oct 2009 17:25:17 -0400
Message-ID: <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
From: Parag Warudkar <parag.lkml@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> Can you try this patch ?
>
> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Tue Oct 27 15:36:38 2009 +0530
>
>    ext4: discard preallocation during truncate
>
>    We need to make sure when we drop and reacquire the inode's
>    i_data_sem we discard the inode preallocation. Otherwise we
>    could have blocks marked as free in bitmap but still belonging
>    to prealloc space.

Just wanted to let you know that I have applied this patch and one
unclean shutdown later it seems to have not given me any trouble.

I will continue testing it - hopefully I won't have to reformat  this
time ( every time I tested previously I ended up having weird issues
that I decided to get rid of by reformatting /).

Parag
