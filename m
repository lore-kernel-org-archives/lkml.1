Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbXLFBr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbXLFBr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXLFBrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:47:18 -0500
Received: from mail.arctic.org ([208.69.40.137]:34573 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751907AbXLFBrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:47:17 -0500
Message-ID: <47575492.5040707@kernel.org>
Date: Wed, 05 Dec 2007 17:46:58 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 - add-64-bit-capability-support-to-the-kernel
References: <14896.1196497105@turing-police.cc.vt.edu> <20071203150308.GD9008@sergelap.austin.ibm.com>
In-Reply-To: <20071203150308.GD9008@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
>> Question:
>>
>> The patch does the semantic equivalent of:
>>
>> -#define cap_clear(c)         do { cap_t(c) =  0; } while(0)
>> -#define cap_set_full(c)      do { cap_t(c) = ~0; } while(0)
>>
>> +# define cap_clear(c)         do { (c) = __cap_empty_set; } while (0)
>> +# define cap_set_full(c)      do { (c) = __cap_full_set; } while (0)
>> +# define cap_set_init_eff(c)  do { (c) = __cap_init_eff_set; } while (0)
>>
>> Was it intentional, or an oversight, that this blows chunks in modules
>> that try to use cap_clear() or cap_set_full() because the __cap_*
>> symbols don't get an EXPORT_SYMBOL() attached to them?

Definitely an oversight. Thanks Serge for the fix!

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHV1SP+bHCR3gb8jsRAtikAJ9FEm6ETGa9qrr82kLI4ZtsACZ43gCgqIcY
GbuHBsxpaZtQDEgU/3OCgA0=
=A9+O
-----END PGP SIGNATURE-----
