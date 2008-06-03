Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYFCRjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYFCRjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYFCRjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:39:46 -0400
Received: from testure.choralone.org ([194.9.77.134]:38876 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbYFCRjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:39:45 -0400
Date: Tue, 3 Jun 2008 13:42:18 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: maximilian attems <max@stro.at>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       cking <colin.king@canonical.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] Enable speedstep for sonoma processors.
Message-ID: <20080603174218.GA15293@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	maximilian attems <max@stro.at>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, cking <colin.king@canonical.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>
References: <1212512656-13462-1-git-send-email-max@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212512656-13462-1-git-send-email-max@stro.at>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 07:04:16PM +0200, maximilian attems wrote:
 > From: cking <colin.king@canonical.com>
 > 
 > OriginalAuthor: Christophe Dumez, repackaged by Wolfgang Tremmel
 > OriginalLocation: http://launchpadlibrarian.net/11575235/speedstep-sonoma.patch Bug: 132271
 > 
 > Signed-off-by: cking <colin.king@canonical.com>
 > Signed-off-by: maximilian attems <max@stro.at>
 > ---
 >  arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   93 ++++++++++++++++++++++
 >  1 files changed, 93 insertions(+), 0 deletions(-)

This patch has been floating around for years.
So long, I've forgotten the original reason it wasn't accepted.
It had something to do with it working for some users, but not others,
and we can't detect the 'not working' case.

speedstep-centrino is also deprecated in favour of acpi-cpufreq for some time.
If acpi isn't working on these machines, we should find out why.

	Dave

 > diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
 > index 908dd34..6d6896e 100644
 > --- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
 > +++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
 > @@ -44,6 +44,7 @@ enum {
 >  	CPU_DOTHAN_A1,
 >  	CPU_DOTHAN_A2,
 >  	CPU_DOTHAN_B0,
 > +	CPU_DOTHAN_C0,
 >  	CPU_MP4HT_D0,
 >  	CPU_MP4HT_E0,
 >  };
 > @@ -53,6 +54,7 @@ static const struct cpu_id cpu_ids[] = {
 >  	[CPU_DOTHAN_A1]	= { 6, 13, 1 },
 >  	[CPU_DOTHAN_A2]	= { 6, 13, 2 },
 >  	[CPU_DOTHAN_B0]	= { 6, 13, 6 },
 > +	[CPU_DOTHAN_C0]	= { 6, 13, 8 },
 >  	[CPU_MP4HT_D0]	= {15,  3, 4 },
 >  	[CPU_MP4HT_E0]	= {15,  4, 1 },
 >  };
 > @@ -194,6 +196,88 @@ static struct cpufreq_frequency_table banias_1700[] =
 >  };
 >  #undef OP
 >  
 > +
 > +#define OPEX(mhz, base, mva, mvb, mvc, mvd)                     \
 > +{                                                               \
 > +        .frequency = (mhz) * 1000,                              \
 > +        .index = (((mhz)/(base)) << 8) | ((mva - 700) / 16)     \
 > +}
 > +
 > +/* Intel Pentium M processor 730 / 1.60 GHz (Sonoma) */
 > +static struct cpufreq_frequency_table sonoma_1596[] =
 > +{
 > +        OPEX( 798, 133,  988,  988,  988,  988),
 > +        OPEX(1064, 133, 1116, 1111, 1084, 1079),
 > +        OPEX(1330, 133, 1244, 1233, 1180, 1169),
 > +        OPEX(1596, 133, 1356, 1356, 1260, 1260),
 > +        { .frequency = CPUFREQ_TABLE_END }
 > +};
 > +
 > +/* Intel Pentium M processor 740 / 1.73 GHz (Sonoma) */
 > +static struct cpufreq_frequency_table sonoma_1729[] =
 > +{
 > +        OPEX( 798, 133,  988,  988,  988,  988),
 > +        OPEX(1064, 133, 1100, 1093, 1068, 1066),
 > +        OPEX(1330, 133, 1212, 1198, 1148, 1143),
 > +        OPEX(1729, 133, 1356, 1356, 1260, 1260),
 > +        { .frequency = CPUFREQ_TABLE_END }
 > +};
 > +
 > +/* Intel Pentium M processor 750 / 1.86 GHz (Sonoma) */
 > +static struct cpufreq_frequency_table sonoma_1862[] =
 > +{
 > +        OPEX( 798, 133,  988,  988,  988,  988),
 > +        OPEX(1064, 133, 1084, 1080, 1068, 1056),
 > +        OPEX(1330, 133, 1180, 1172, 1132, 1124),
 > +        OPEX(1596, 133, 1276, 1264, 1196, 1192),
 > +        OPEX(1862, 133, 1356, 1356, 1260, 1260),
 > +        { .frequency = CPUFREQ_TABLE_END }
 > +};
 > +
 > +/* Intel Pentium M processor 760 / 2.00 GHz (Sonoma) */
 > +static struct cpufreq_frequency_table sonoma_1995[] =
 > +{
 > +        OPEX( 798, 133, 988, 988, 988, 988),
 > +        OPEX(1064, 133, 1084, 1070, 1052, 1048),
 > +        OPEX(1330, 133, 1164, 1152, 1116, 1109),
 > +        OPEX(1596, 133, 1244, 1233, 1180, 1169),
 > +        OPEX(1995, 133, 1356, 1356, 1260, 1260),
 > +        { .frequency = CPUFREQ_TABLE_END }
 > +};
 > +/* Intel Pentium M processor 770 / 2.13 GHz (Sonoma) */
 > +static struct cpufreq_frequency_table sonoma_2128[] =
 > +{
 > +        OPEX( 798, 133, 988, 988, 988, 988),
 > +        OPEX(1064, 133, 1068, 1065, 1052, 1042),
 > +        OPEX(1330, 133, 1148, 1142, 1100, 1097),
 > +        OPEX(1596, 133, 1228, 1218, 1164, 1151),
 > +        OPEX(1862, 133, 1308, 1295, 1212, 1206),
 > +        OPEX(2128, 133, 1372, 1372, 1260, 1260),
 > +        { .frequency = CPUFREQ_TABLE_END }
 > +};
 > +
 > +/* Intel Pentium M processor 780 / 2.26 GHz (Sonoma) */
 > +static struct cpufreq_frequency_table sonoma_2261[] =
 > +{
 > +        OPEX( 798, 133, 988, 988, 988, 988),
 > +        OPEX(1064, 133, 1068, 1064, 1052, 1037),
 > +        OPEX(1330, 133, 1148, 1139, 1100, 1087),
 > +        OPEX(1596, 133, 1228, 1215, 1148, 1136),
 > +        OPEX(1862, 133, 1292, 1291, 1196, 1186),
 > +        OPEX(2261, 133, 1404, 1404, 1260, 1260),
 > +        { .frequency = CPUFREQ_TABLE_END }
 > +};
 > +
 > +#undef OPEX
 > +
 > +#define SONOMA(cpuid, max, base, name)  \
 > +{       .cpu_id         = cpuid,        \
 > +        .model_name     = "Intel(R) Pentium(R) M processor " name "GHz", \
 > +        .max_freq       = (max)*1000,   \
 > +        .op_points      = sonoma_##max, \
 > +}
 > +
 > +
 >  #define _BANIAS(cpuid, max, name)	\
 >  {	.cpu_id		= cpuid,	\
 >  	.model_name	= "Intel(R) Pentium(R) M processor " name "MHz", \
 > @@ -216,6 +300,15 @@ static struct cpu_model models[] =
 >  	BANIAS(1600),
 >  	BANIAS(1700),
 >  
 > +        /* Builtin tables for Dothan C0 CPUs, a.k.a Sonoma */
 > +        SONOMA(&cpu_ids[CPU_DOTHAN_C0], 1596, 133, "1.60"),
 > +        SONOMA(&cpu_ids[CPU_DOTHAN_C0], 1729, 133, "1.73"),
 > +        SONOMA(&cpu_ids[CPU_DOTHAN_C0], 1862, 133, "1.86"),
 > +        SONOMA(&cpu_ids[CPU_DOTHAN_C0], 1995, 133, "2.00"),
 > +        SONOMA(&cpu_ids[CPU_DOTHAN_C0], 2128, 133, "2.13"),
 > +        SONOMA(&cpu_ids[CPU_DOTHAN_C0], 2261, 133, "2.26"),
 > +
 > +
 >  	/* NULL model_name is a wildcard */
 >  	{ &cpu_ids[CPU_DOTHAN_A1], NULL, 0, NULL },
 >  	{ &cpu_ids[CPU_DOTHAN_A2], NULL, 0, NULL },
 > -- 
 > 1.5.5.1
 > 
---end quoted text---

-- 
http://www.codemonkey.org.uk
