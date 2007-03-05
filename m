Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXCEL0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXCEL0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbXCEL0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:26:10 -0500
Received: from highlandsun.propagation.net ([66.221.212.168]:3704 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933069AbXCEL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:26:08 -0500
Message-ID: <45EBFD13.1060106@symas.com>
Date: Mon, 05 Mar 2007 03:20:51 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a3pre) Gecko/20070302 SeaMonkey/1.5a
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: TCP 2MSL on loopback
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why is the Maximum Segment Lifetime a global parameter? Surely the 
maximum possible lifetime of a particular TCP segment depends on the 
actual connection. At the very least, it would be useful to be able to 
set it on a per-interface basis. E.g., in the case of the loopback 
interface, it would be useful to be able to set it to a very small duration.

As I note in this draft 
http://www.ietf.org/internet-drafts/draft-chu-ldap-ldapi-00.txt
when doing a connection soak test of OpenLDAP using clients connected 
through localhost, the entire port range is exhausted in well under a 
second, at which point the test stalls until a port comes out of 
TIME_WAIT state so the next connection can be opened.

These days it's not uncommon for an OpenLDAP slapd server to handle tens 
of thousands of connections per second in real use (e.g., at Google, or 
at various telcos). While the LDAP server is fast enough to saturate 
even 10gbit ethernet using contemporary CPUs, we have to resort to 
multiple virtual interfaces just to make sure we have enough port 
numbers available.

Ideally the 2MSL parameter would be dynamically adjusted based on the 
route to the destination and the weights associated with those routes. 
In the simplest case, connections between machines on the same subnet 
(i.e., no router hops involved) should have a much smaller default value 
than connections that traverse any routers. I'd settle for a two-level 
setting - with no router hops, use the small value; with any router hops 
use the large value.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc
   Chief Architect, OpenLDAP     http://www.openldap.org/project/
