Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZKKPJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZKKPJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZKKPJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:09:54 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64878 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZKKPJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:09:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KfRfC8jMOnIZWLFJ6EFarCd+hNmPZAhTwHuG+j6go05YZeLkTbGcHWEX+DuUZPXNE2
         ghO8ZpB+EdRQKe4we20nJdFxqgcVMrNaOSrWMcpWoaKTq1H5GvpHQst0GFoirM4M4IbZ
         fXsTKJfNziykgPfbec04uudbyIQFxVHVDGPgg=
MIME-Version: 1.0
In-Reply-To: <2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com>
References: <cover.1257864802.git.andre.goddard@gmail.com>
	 <2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com>
Date: Wed, 11 Nov 2009 13:09:57 -0200
Message-ID: <a4c8a6d00911110709j65b54875sb9e56edf0a32c28d@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle 
	comparison element
From: Thiago Farina <tfransosi@gmail.com>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 1:00 PM, André Goddard Rosa
<andre.goddard@gmail.com> wrote:
>  void *bsearch(const void *key, const void *base, size_t num, size_t size,
>              int (*cmp)(const void *key, const void *elt))
>  {
> -       int start = 0, end = num, mid, result;
> +       size_t start = 0, end = num;
> +       int result;
>
>        while (start < end) {
> -               mid = (start + end) / 2;
> +               size_t mid = start + (end - start) / 2;
I think it is more readable if you could keep the mid variable outside
of the while loop.
