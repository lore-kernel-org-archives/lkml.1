Return-Path: <linux-kernel-owner+w=401wt.eu-S2992865AbXEBHKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992865AbXEBHKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992874AbXEBHKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:10:19 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:21806 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992865AbXEBHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:10:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=C5JAjoF5sBtAawSpWsLuZbKB1UmsDlScGBNAjM+GS8dLCk6klCymFZg6StUHdu9cOoIdcDTIEkCqsnMI/dUzXphWBfWvpFnC3cRQplS8sjx8Qy99YALIarN8mbH+W8yiPPYkaSuonMy1wYVC3ZeMsH91AFR6gbq/hEsvz/5WihY=  ;
X-YMail-OSG: 2jp6NfYVM1k9kHoS842YKT3jsKX15LhSuGj6m3P99YYHWRlb0xWoqBeMQttAIYbjIk_jdJv2bw--
Message-ID: <4638394F.60609@yahoo.com.au>
Date: Wed, 02 May 2007 17:10:07 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46338AEB.2070109@imap.cc>	<20070428141024.887342bd.akpm@linux-foundation.org>	<4636248E.7030309@imap.cc>	<20070430112130.b64321d3.akpm@linux-foundation.org>	<46364346.6030407@imap.cc> <20070430124638.10611058.akpm@linux-foundation.org> <46383742.9050503@imap.cc>
In-Reply-To: <46383742.9050503@imap.cc>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 30.04.2007 21:46 schrieb Andrew Morton:
> 
>>Not really - everything's tangled up.  A bisection search on the
>>2.6.21-rc7-mm2 driver tree would be the best bet.
> 
> 
> And the winner is:
> 
> gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch

+	struct kobject *top_kobj;
+	struct kset *kset;
+	char *envp[32];
+	char data[PAGE_SIZE];
+	char *pos;
+	int i;
+	size_t count = 0;
+	int retval;

... that seems like a lot of stack to be using.

-- 
SUSE Labs, Novell Inc.
