Return-Path: <linux-kernel-owner+w=401wt.eu-S965801AbXCIMiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801AbXCIMiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964935AbXCIMiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:38:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:31405 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767215AbXCIMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:38:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UCxsScJwGzerjlkCP0El8uUJ0+fDmCO1dZUEwrKy4KKuPuQq55j1IBbOLb5PcTPwkvL6FCugQ2ldjHFNwztGNCewmjVHdW/IAcZwhem8Z4alzrN7WXUgCyuvhpUVujUar/LecO9jCj1YVh96yeg6U+SCCYFmzU9IKAR1Royhw+I=
Message-ID: <84144f020703090438y484605a0i3cf6b547b953a4db@mail.gmail.com>
Date: Fri, 9 Mar 2007 14:38:10 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
Subject: Re: [PATCH] revoke: delayed file closing
Cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703091423260.17046@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703091423260.17046@sbz-30.cs.Helsinki.FI>
X-Google-Sender-Auth: e25d714d8bf73e5f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> To fix this, change sys_revoke() not to close the actual revoked file
> immediately. Instead, we do filp_close() when the user does close(2)
> on the revoked file descriptor.

Btw, this is safe because a filesystem implementing f_ops->revoke must
ensure there are no pending writes after it has completed so
f_ops->flush will not do any actual flushing when it is invoked by a
delayed close.
