Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZALS64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZALS64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZALS6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:58:47 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:54772 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZALS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:58:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qhRC94+ZBrfZyKAvydouxcd9RtLaeoevwqc7QCyodVupuI2NZm6xLdXx6OEa4RHWC+
         oyGiuieM7PxiqB0zEf1XPiL9FVoZ091SZHtHkzqFX7ReyCiZh2Jk4UO3B15IQokRA+xu
         3wpuCTA7C36XmLuTAGke9gVScoMgc1lzepOYE=
Message-ID: <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
Date: Mon, 12 Jan 2009 12:58:42 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <496B899E.7060605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
	 <496B899E.7060605@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not just the cifs md5 one (which has been around a long
time), but an md5_init (static) in crypto and the new one in rt.  The
addition of the new one (rt md5_init) causes the build problem.   It
would be nice if we could use the same md5 routines though ... last
time we checked the crypto one was not well suited for calculating
signatures as a network fs would do though.

On Mon, Jan 12, 2009 at 12:19 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> Some people took me at my word and so we have the 2.6.30 code starting to
>> trickle in already.
>
>
>
> When CIFS is built-in (=y) and staging/rt28[67]0 =y, there are multiple
> definitions of:
>
> build-r8250.out:(.text+0x1d8ad0): multiple definition of `MD5Init'
> build-r8250.out:(.text+0x1dbb30): multiple definition of `MD5Update'
> build-r8250.out:(.text+0x1db9b0): multiple definition of `MD5Final'
>
> all of which need to have more unique identifiers for their global
> symbols (e.g., rt28_md5_init, cifs_md5_init, foo, blah, bar).
>
>
> --
> ~Randy
>



-- 
Thanks,

Steve
