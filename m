Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYIWGMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYIWGMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYIWGM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:12:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:34151 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbYIWGM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:12:28 -0400
Date: Mon, 22 Sep 2008 23:12:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: James Morris <jmorris@namei.org>
cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
In-Reply-To: <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org>
Message-ID: <alpine.DEB.1.10.0809222310450.25430@asgard.lang.hm>
References: <48C65E9D.3070106@nttdata.co.jp> <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp>
 <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, James Morris wrote:

> On Wed, 17 Sep 2008, Kentaro Takeda wrote:
>
>> TOMOYO Linux needs method for calculating pathname in LSM module.
>> However, we have received comment from Al Viro, the vfs maintainer,
>> that adding vfsmount parameter to vfs helper functions (and LSM hooks)
>> is not preferable. We have asked some people (including Al), and we
>> came back to the most straightforward approach; adding new LSM hooks
>> where vfsmount is available.
>>
>> The attached patch introduces several new LSM hooks TOMOYO Linux
>> needs. It has less impact to existing LSM module and no impact to vfs
>> helper functions. Please review it.
>
> I don't see any technical errors in this patch.
>
> If it is going to be merged, please make a new config option for
> path-based hooks (similar to that for the network hooks), so they can be
> compiled out.

one question about these new hook locations.

it is possible to gather all the info that was gathered at the old hook 
locations from the new ones? I realize that you are not eliminating the 
old hooks (and possibly can't for backwards compatibility), but possibly 
they should be depriciated in favor of the new locations if they can 
satisfy both the old uses and new use cases.

David Lang
