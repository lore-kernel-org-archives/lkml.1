Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZG1Mee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZG1Mee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZG1Med
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:34:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZG1Meb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:34:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Gi+b0tov9L7hd/aG4LK/6lnc8AQAnJlOv5qtZy1ruDveqH/F07DLD52ssF1WR5RiL
	FiqNYP1iaXebNA5sqhkvg==
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0907272037500.20984@fbirervta.pbzchgretzou.qr>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
	 <20090727134852.13319.39035.stgit@jazzy.zrh.corp.google.com>
	 <alpine.LSU.2.00.0907272037500.20984@fbirervta.pbzchgretzou.qr>
Date: Tue, 28 Jul 2009 14:34:26 +0200
Message-ID: <b5ddba180907280534l78eaf951j53048ebfbef4258c@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] libxt_ipvs: user space lib for netfilter matcher 
	xt_ipvs
From: Hannes Eder <heder@google.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 20:40, Jan Engelhardt<jengelh@medozas.de> wrote:
>
> On Monday 2009-07-27 15:48, Hannes Eder wrote:
>>+
>>+      switch (c) {
>>+      case '0': /* --ipvs */
>>+              /* Nothing to do here. */
>
>                Then why add it?

In the 'default' branch is an assert(false);  Call it defensive programming.

>>+      char buf[BUFSIZ];
>>+
>>+      if (family == NFPROTO_IPV4) {
>>+              if (!numeric && addr->ip == 0) {
>>+                      printf("anywhere ");
>>+                      return;
>>+              }
>>+              if (numeric)
>>+                      strcpy(buf, xtables_ipaddr_to_numeric(&addr->in));
>>+              else
>>+                      strcpy(buf, xtables_ipaddr_to_anyname(&addr->in));
>>+              strcat(buf, xtables_ipmask_to_numeric(&mask->in));
>>+              printf("%s ", buf);
>
> There is no need to use the strcpy/strcat hacks. Just directly printf it.

As the comment says: "Shamelessly copied from libxt_conntrack.c". ;)

Furthermore I think it is good that way, because
xtables_ipaddr_to_numeric writes to a local static buffer, and
xtables_ipaddr_to_numeric might get called by
xtables_ipmask_to_numeric.

>>--- /dev/null
>>+++ b/extensions/libxt_ipvs.man
>>@@ -0,0 +1,7 @@
>>+ipvs tests where the packet was modified by IPVS, i.e. is the
>>+skb_buff->ipvs_property set.
>>+.TP
>>+[\fB!\fP] \fB--ipvs
>>+Does the packet have to IPVS property?
>>+
>>+TODO: Write proper documentation.
>
> Yes.

Sir, yes, sir ;) I am working on that.

Thanks,
-Hannes
