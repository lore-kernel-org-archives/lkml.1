Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXLDPVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXLDPVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXLDPVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:21:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:27381 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbXLDPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WJ7vrCYl8vIshPJL3Z+Kp3WNwyMVh0V5nfNAcZUKRtOGYYYFqhRDkYF2Qcc/q9xgmb54Yw8aV8uwOVH/3D0v525C3RZ/awVnL5w5ErsR32fuVeoEKCHcTCz4akvp+n2/g8qo0QWvf4+qWipMmNTGf7zQWuAJpDtl8OXsG9H/daU=
Message-ID: <47557076.8080508@gmail.com>
Date: Wed, 05 Dec 2007 00:21:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
References: <47555AF1.8090304@gmail.com> <20071204150734.GE6113@hacking>
In-Reply-To: <20071204150734.GE6113@hacking>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
>> +static inline unsigned int sdb_hash(const char *str)
>> +{
>> +        unsigned int hash = 0;
>> +        int c;
>> +
>> +        while ((c = *str++))
> 
> Maybe ` while ((c = *str++) != '\0') ` is better. ;)

Yeah, probably.  That hash function is copied & pasted mindlessly from web.

>> +		hash = c + (hash << 6) + (hash << 16) - hash;
>> +
>> +        return hash;
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	unsigned int nr_entries = 0;
>> +	struct hash_ent **hash_tbl;
>> +	char line[10240];
> 
> Needs to #define the magic number?

Or maybe write a wrapper function around fgets() to detect long lines
reliably.

>> +		while (fgets(line, sizeof(line), fp)) {
>> +			int len = strlen(line);
> 
> strlen returns 'size_t', which is unsigned.

It's capped by the magic number above but yeah size_t would be better.

> I think, you forgot to free(3) the memory you calloc(3)'ed and
> malloc(3)'ed above.

It's a simple program where whole body is in main().  Why bother?
What's the benefit of adding hash-table iterating free logic?

-- 
tejun
