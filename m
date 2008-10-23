Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJWOPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJWOPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYJWOOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:14:44 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35280 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYJWOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=K1vqCNqfAgC09h7FrePh5eJE/0X/Y4JFmMJCPNKpA19svx+6Cl8t05ye/JkHv/m0CP
         /bEOyZKRcOxLu1faJzw/0NRYONAFWKQcNp8X6Bpl5nLUbRrheKhRsgg0JzKIyrMLuDCj
         ooCGRmgGe9G/43r9DA14SjmHdLi6e7zb1uOlk=
Message-ID: <84144f020810230714g7f5d36bas812ad691140ee453@mail.gmail.com>
Date: Thu, 23 Oct 2008 17:14:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: SLUB defrag pull request?
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0810230705210.12497@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223883004.31587.15.camel@penberg-laptop>
	 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
	 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221416130.26639@quilx.com>
	 <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
	 <1224745831.25814.21.camel@penberg-laptop>
	 <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810230638450.11924@quilx.com>
	 <84144f020810230658o7c6b3651k2d671aab09aa71fb@mail.gmail.com>
	 <Pine.LNX.4.64.0810230705210.12497@quilx.com>
X-Google-Sender-Auth: 503f1e1927749f7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 5:09 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Got a draft of a patch here that does freelist handling differently. Instead
> of building linked lists it uses free objects to build arrays of pointers to
> free objects. That improves cache cold free behavior since the object
> contents itself does not have to be touched on free.
>
> The problem looks like its freeing objects on a different processor that
> where it was used last. With the pointer array it is only necessary to touch
> the objects that contain the arrays.

Interesting. SLAB gets away with this because of per-cpu caches or
because it uses the bufctls instead of a freelist?
