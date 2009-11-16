Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZKPQqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZKPQqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZKPQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:46:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbZKPQqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:46:06 -0500
Message-ID: <4B018157.3080707@redhat.com>
Date: Mon, 16 Nov 2009 17:44:07 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       device-mapper development <dm-devel@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/7] Reduce GFP_ATOMIC allocation failures, candidate
 fix V3
References: <1258054211-2854-1-git-send-email-mel@csn.ul.ie> <20091112202748.GC2811@think> <20091112220005.GD2811@think> <20091113024642.GA7771@think>
In-Reply-To: <20091113024642.GA7771@think>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 03:46 AM, Chris Mason wrote:
> On Thu, Nov 12, 2009 at 05:00:05PM -0500, Chris Mason wrote:
> 
> [ ...]
> 
>>
>> The punch line is that the btrfs guy thinks we can solve all of this with
>> just one more thread.  If we change dm-crypt to have a thread dedicated
>> to sync IO and a thread dedicated to async IO the system should smooth
>> out.

Please, can you cc DM maintainers with these kind of patches? dm-devel list at least.

Note that the crypt requests can be already processed synchronously or asynchronously,
depending on used crypto module (async it is in the case of some hw acceleration).

Adding another queue make the situation more complicated and because the crypt
requests can be queued in crypto layer I am not sure that this solution will help
in this situation at all.
(Try to run that with AES-NI acceleration for example.)


Milan
--
mbroz@redhat.com
