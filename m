Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZIZMNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZIZMNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZIZMNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:13:35 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:50008 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZIZMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=v2lRhzRwFD/IRWfVHBI7k+4jmMIsWEEceYjH2hBphErq4dfH5X26DC6Wi57RHzPztT
         ZnmL3T42kvvI353B7Zkee5Lv3qu0hXfanG7moANqDpCsCYeAimo8p1DIqQ2VCJV55C4C
         v9etW1d9Ea/aOiCNYSI/hx2G+vnzh7kXcrS6w=
Message-ID: <4ABE056F.6090005@tuffmail.co.uk>
Date: Sat, 26 Sep 2009 13:13:35 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: rusty@rustcorp.com.au
CC: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] module: unexport each_symbol()
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1253626718-18887-4-git-send-email-alan-jenkins@tuffmail.co.uk> <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu> <20090923220022.GB30818@infradead.org>
In-Reply-To: <20090923220022.GB30818@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Sep 23, 2009 at 01:29:43PM -0400, Tim Abbott wrote:
>   
>> While Ksplice is not in-tree yet, Ksplice is a user of each_symbol (and in 
>> fact was the reason why each_symbol was originally exported).  Is it easy 
>> to modify your patch series so that you don't have to remove each_symbol?
>>     
>
> We don't keep symbols for out of tree junk around.
>   

We do alter them mercilessly though :-).

I don't want to preserve the current implementation of each_symbol()
because it duplicates too much of the modified find_symbol().  However,
the duplicated code can be simplified if I changed the various "syms"
fields in struct module with a single array (without increasing the size
of struct module).  I consider this a cleanup; it would benefit a couple
of other sites in module.c as well.

The change would make "struct symsearch" redundant - changing the
interface of each_symbol().  If Ksplice fails to merge quickly enough it
will still be easy to remove each_symbol(), and we'll still benefit from
the cleanup in find_symbol() and elsewhere.

Rusty, does that make sense to you?

Thanks
Alan
