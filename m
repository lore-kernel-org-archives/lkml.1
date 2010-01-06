Return-Path: <linux-kernel-owner+w=401wt.eu-S932427Ab0AFRbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0AFRbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376Ab0AFRbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:31:37 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44442 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab0AFRbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hoy+Imdbr5qi1k5k6r/fh/kJRJhsfaRg3MFpF/GEaAjDnpDcrcJf1nCKxChS5wSk+t
         1iKY8gJnrvG57vs82Ld8500+O1SEkXjJ8YaRlvMlhrCrtgHe4Cd2XWQJTFt1APGObzOp
         eh0tsuhaN5VWzrDfvB1dp9B+U40B2MkxzwhLc=
Message-ID: <4B44C8F4.7030900@gmail.com>
Date: Wed, 06 Jan 2010 18:31:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Jiri Slaby <jslaby@suse.cz>, jmorris@namei.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] cred: fix memory leak
References: <1262797265-26557-1-git-send-email-jslaby@suse.cz> <20100106172541.GB15784@us.ibm.com>
In-Reply-To: <20100106172541.GB15784@us.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 06:25 PM, Serge E. Hallyn wrote:
> Quoting Jiri Slaby (jslaby@suse.cz):
>> Stanse found a memory leak in prepare_exec_creds. tgcred is not
>> freed/assigned on all paths. Fix that.
>>
>> I.e. unifdef tgcred and add kfree(tgcred); as it is initialized to
>> NULL already.
> 
> Does this compile with CONFIG_KEYS=n, , though? 

Yes and I guess it's due to no dereference of the pointer.

> Should this patch add one?

Hmm, I don't think so. The patch is ugly in the light of not having the
struct defined. I should come up with something where the CONFIG_KEYS is
left there.

thanks,
-- 
js
