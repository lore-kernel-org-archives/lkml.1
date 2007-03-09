Return-Path: <linux-kernel-owner+w=401wt.eu-S1767152AbXCIKnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767152AbXCIKnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767157AbXCIKnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:43:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:18601 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767152AbXCIKnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:43:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a9e69Ytfmo/a1+r6oXJUVNlaGucdvZK/f/iwKU3EOPejhztXIym5vxQ7OqGtUVaX4ZCCeX/FxmaoNRGAP9q344GDJtnctaL8lr2SFWYx3MlZEZVhh170rM+iumsJD77YEVa0hPnB7YuIvylk25suW60SZdskUumUVghriuarQU8=
Message-ID: <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com>
Date: Fri, 9 Mar 2007 12:43:36 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <200703091108.58371.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
	 <200703091108.58371.dada1@cosmosbay.com>
X-Google-Sender-Auth: 438d5f9696d4521d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Cannot we use a flag in 'struct files_struct', set to one when the task is
> mono-thread (at task creation in fact), and set to 0 when it creates a new
> thread  (or when someone remotely access to this "struct files_struct"
> in /proc/pid/fd/... )

How does that work? fget_light() has a built-in assumption that as
long as you don't share files_struct, it's okay not to take an extra
reference as current is only one doing close(2) and revoke(2) changes
that. So it's not really about being single-threaded or not.

On 3/9/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Also, the thing is racy.

Aah, fget_light() indeed has a race window between fcheck_files() and
set_f_light().
